import Foundation

enum ThemeStyle: String, CaseIterable, Codable { case cleanLight, darkPro, playful }

enum Belt: String, Codable, CaseIterable, Comparable {
    case white, yellow, green, blue, black
    var title: String {
        switch self {
        case .white: return "White Belt"
        case .yellow: return "Yellow Belt"
        case .green: return "Green Belt"
        case .blue: return "Blue Belt"
        case .black: return "Black Belt"
        }
    }
    var order: Int { [.white:0,.yellow:1,.green:2,.blue:3,.black:4][self]! }
    static func < (lhs: Belt, rhs: Belt) -> Bool { lhs.order < rhs.order }
}

enum ExerciseType: String, Codable { case predictOutput, fillBlank, debug, arrangeBlocks, typeCode, projectStep }

struct Exercise: Identifiable, Codable, Hashable {
    let id: String
    let type: ExerciseType
    let promptMarkdown: String
    let starterCode: String?
    let choices: [String]?
    let answer: String?
    let tests: [CodeTest]?
}

struct CodeTest: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let input: String?
    let expectedOutputContains: String
}

struct Lesson: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let belt: Belt
    let estimatedMinutes: Int
    let exercises: [Exercise]
}

struct Curriculum: Codable { let lessons: [Lesson] }

struct DailyGoal: Codable, Hashable { var minutesPerDay: Int = 5 }

struct UserProgress: Codable {
    var completedLessonIDs: Set<String> = []
    var xp: Int = 0
    var streakDays: Int = 0
    var lastActiveISODate: String? = nil
    var dailyGoal: DailyGoal = DailyGoal()
    var kunai: Int = 0
}
