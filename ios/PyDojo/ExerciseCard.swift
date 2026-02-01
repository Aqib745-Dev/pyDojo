import SwiftUI

struct ExerciseCard: View {
    @EnvironmentObject var vm: AppVM
    let exercise: Exercise
    let onResult: (Bool, String) -> Void

    @State private var selected: String? = nil
    @State private var code: String = ""
    @State private var output: String = ""
    @State private var running: Bool = false

    var body: some View {
        let theme = Theme(style: vm.themeStyle)
        VStack(alignment: .leading, spacing: 12) {
            Text(exercise.promptMarkdown).font(.body)

            if let starter = exercise.starterCode {
                Text("Code").font(.caption).bold().foregroundStyle(theme.text.opacity(0.75))
                CodeEditor(text: $code).onAppear { if code.isEmpty { code = starter } }
            }

            if let choices = exercise.choices, !choices.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(choices, id: \ .self) { c in
                        Button { selected = c } label: {
                            HStack {
                                Text(c).font(.subheadline)
                                Spacer()
                                if selected == c { Image(systemName: "checkmark.circle.fill") }
                            }
                            .padding()
                            .background(theme.card)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }.buttonStyle(.plain)
                    }
                }
            }

            Button { Task { await submit() } } label: {
                HStack { if running { ProgressView().scaleEffect(0.9) }; Text(running ? "Checking..." : "Check") }
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(running)

            if !output.isEmpty {
                Text(output)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(theme.codeBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding()
        .background(theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func submit() async {
        output = ""
        switch exercise.type {
        case .predictOutput, .fillBlank, .arrangeBlocks:
            guard let selected else { onResult(false, "Pick an answer."); return }
            let ok = (selected == exercise.answer)
            onResult(ok, ok ? "Correct." : "Not quite. Try again.")
        case .debug, .typeCode, .projectStep:
            running = true
            defer { running = false }
            do {
                let res = try await APIClient.shared.runPython(code: code, stdin: nil)
                output = (res.stderr.isEmpty ? res.stdout : (res.stdout + "\n" + res.stderr))
                if let tests = exercise.tests, !tests.isEmpty {
                    let combined = (res.stdout + "\n" + res.stderr)
                    let ok = tests.allSatisfy { t in
                        if t.expectedOutputContains.isEmpty {
                            return combined.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
                        }
                        return combined.contains(t.expectedOutputContains)
                    } && res.passed
                    onResult(ok, ok ? "Good." : "Output doesn't match yet.")
                } else {
                    onResult(res.passed, res.passed ? "Looks good." : "Still failing.")
                }
            } catch {
                output = "Error: \(error.localizedDescription)"
                onResult(false, "Execution error.")
            }
        }
    }
}
