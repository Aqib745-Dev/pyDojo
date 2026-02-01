import Foundation

final class ProgressStore {
    static let shared = ProgressStore()
    private init() {}
    private let key = "pydojo_user_progress_v2"
    func load() -> UserProgress {
        guard let data = UserDefaults.standard.data(forKey: key) else { return UserProgress() }
        return (try? JSONDecoder().decode(UserProgress.self, from: data)) ?? UserProgress()
    }
    func save(_ progress: UserProgress) {
        if let data = try? JSONEncoder().encode(progress) { UserDefaults.standard.set(data, forKey: key) }
    }
}
