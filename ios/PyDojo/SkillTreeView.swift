import SwiftUI

struct SkillTreeView: View {
    @EnvironmentObject var vm: AppVM

    var body: some View {
        let theme = Theme(style: vm.themeStyle)
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    MascotHeader(title: "Train your Python daily",
                                subtitle: "Goal: \(vm.dailyGoalMinutes()) min • Streak: \(vm.progress.streakDays) days")
                    BeltStrip(current: vm.unlockedBelt())
                    ForEach(Belt.allCases, id: \ .self) { belt in
                        BeltSection(belt: belt)
                    }
                }
                .padding()
            }
            .background(theme.background.ignoresSafeArea())
            .navigationTitle("PyDojo")
        }
    }
}

private struct BeltStrip: View {
    @EnvironmentObject var vm: AppVM
    let current: Belt
    var body: some View {
        let theme = Theme(style: vm.themeStyle)
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Belt.allCases, id: \ .self) { belt in
                    Text(belt.title)
                        .font(.caption).bold()
                        .padding(.vertical, 8).padding(.horizontal, 12)
                        .background(belt == current ? theme.accent.opacity(0.18) : theme.card)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(theme.text.opacity(0.10), lineWidth: 1))
                }
            }.padding(.horizontal, 2)
        }
    }
}

private struct BeltSection: View {
    @EnvironmentObject var vm: AppVM
    let belt: Belt
    var body: some View {
        let theme = Theme(style: vm.themeStyle)
        let lessons = vm.curriculum.lessons.filter { $0.belt == belt }
        if lessons.isEmpty { EmptyView() } else {
            VStack(alignment: .leading, spacing: 10) {
                Text(belt.title).font(.headline).padding(.top, 4)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(lessons) { lesson in
                        LessonNode(lesson: lesson, locked: !vm.isLessonUnlocked(lesson))
                    }
                }
            }
            .padding()
            .background(theme.card)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

private struct LessonNode: View {
    @EnvironmentObject var vm: AppVM
    let lesson: Lesson
    let locked: Bool
    var body: some View {
        let theme = Theme(style: vm.themeStyle)
        NavigationLink {
            LessonPlayerView(lesson: lesson)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(lesson.title).font(.subheadline).bold().lineLimit(2)
                    Spacer()
                    if vm.isCompleted(lesson) {
                        Image(systemName: "checkmark.seal.fill").foregroundStyle(theme.accent)
                    } else if locked {
                        Image(systemName: "lock.fill").foregroundStyle(theme.text.opacity(0.5))
                    }
                }
                Text("\(lesson.exercises.count) missions • \(lesson.estimatedMinutes)m")
                    .font(.caption).foregroundStyle(theme.text.opacity(0.7))
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(theme.codeBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(theme.text.opacity(0.10), lineWidth: 1))
        }
        .buttonStyle(.plain)
        .disabled(locked)
        .opacity(locked ? 0.55 : 1.0)
    }
}
