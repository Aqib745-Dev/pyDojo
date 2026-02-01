import Foundation

struct RunCodeRequest: Codable { let code: String; let stdin: String? }
struct RunCodeResponse: Codable { let stdout: String; let stderr: String; let passed: Bool }

final class APIClient {
    static let shared = APIClient()
    private init() {}
    func runPython(code: String, stdin: String? = nil) async throws -> RunCodeResponse {
        let url = AppConfig.API_BASE_URL.appendingPathComponent("/run")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(RunCodeRequest(code: code, stdin: stdin))
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else { throw URLError(.badServerResponse) }
        return try JSONDecoder().decode(RunCodeResponse.self, from: data)
    }
}
