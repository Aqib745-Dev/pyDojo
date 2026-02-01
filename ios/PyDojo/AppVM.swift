import Foundation
import SwiftUI

@MainActor
final class AppVM: ObservableObject {
    @Published var curriculum: Curriculum = Curriculum(lessons: [])
    @Published var progress: UserProgress = ProgressStore.shared.load()
    @Published var themeStyle: ThemeStyle = .cleanLight

    init() { loadCurriculum() }

    func loadCurriculum() {
        guard let url = Bundle.main.url(forResource: "Curriculum", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(Curriculum.self, from: data) else {
            curriculum = Curriculum(lessons: [])
            return
        }
        curriculum = decoded
    }

    func isCompleted(_ lesson: Lesson) -> Bool { progress.completedLessonIDs.contains(lesson.id) }

    func markLessonCompleted(_ lesson: Lesson, awardedXP: Int) {
        if !progress.completedLessonIDs.contains(lesson.id) {
            progress.completedLessonIDs.insert(lesson.id)
            progress.xp += awardedXP
        }
        updateStreak()
        ProgressStore.shared.save(progress)
        objectWillChange.send()
    }

    func unlockedBelt() -> Belt {
        let completed = curriculum.lessons.filter { progress.completedLessonIDs.contains($0.id) }
        return completed.map { $0.belt }.max() ?? .white
    }

    func isLessonUnlocked(_ lesson: Lesson) -> Bool {
        let current = unlockedBelt()
        if lesson.belt <= current { return true }
        let currentLessons = curriculum.lessons.filter { $0.belt == current }
        guard !currentLessons.isEmpty else { return lesson.belt == .white }
        let done = currentLessons.filter { isCompleted($0) }.count
        if Double(done) / Double(currentLessons.count) >= 0.7 {
            return lesson.belt.order == current.order + 1
        }
        return false
    }

    func dailyGoalMinutes() -> Int { max(3, min(progress.dailyGoal.minutesPerDay, 60)) }
    func setDailyGoalMinutes(_ minutes: Int) {
        progress.dailyGoal.minutesPerDay = max(3, min(minutes, 60))
        ProgressStore.shared.save(progress)
        objectWillChange.send()
    }

    func resetAll() {
        progress = UserProgress()
        ProgressStore.shared.save(progress)
        objectWillChange.send()
    }

    private func updateStreak() {
        let today = ISO8601DateFormatter().string(from: Date())
        let dayOnly = String(today.prefix(10))
        if progress.lastActiveISODate == nil {
            progress.lastActiveISODate = dayOnly
            progress.streakDays = 1
            return
        }
        if progress.lastActiveISODate == dayOnly { return }
        progress.lastActiveISODate = dayOnly
        progress.streakDays += 1
    }
}
