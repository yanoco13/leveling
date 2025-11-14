import Foundation


final class APIClient {
    private let baseURL: URL
    private let auth: AuthProvider
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder


    init(baseURL: URL = AppConfig.baseURL, auth: AuthProvider = MockAuthProvider()) {
        self.baseURL = baseURL
        self.auth = auth
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
        self.encoder = JSONEncoder()
        self.encoder.dateEncodingStrategy = .iso8601
    }


    func request<T: Decodable>(_ path: String, method: String = "GET", body: Encodable? = nil, authorized: Bool = true) async throws -> T {
        var url = baseURL
        url.append(path: path)
        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        if authorized, let token = try await auth.getIDToken() {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let body = body { req.httpBody = try encoder.encode(AnyEncodable(body)) }


        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw URLError(.badServerResponse) }


        if (200..<300).contains(http.statusCode) {
        if T.self == Empty.self { return Empty() as! T }
            return try decoder.decode(T.self, from: data)
        }
        if let p = try? decoder.decode(ProblemDetails.self, from: data) { throw p }
        throw URLError(.badServerResponse)
    }


    // Endpoints
    func fetchProfile() async throws -> Profile { try await request("/api/profile") }
    func completeTask(_ req: TaskCompleteRequest) async throws -> TaskCompleteResponse {
        try await request("/api/tasks/complete", method: "POST", body: req)
    }
    func startBattle(opponentUid: String? = nil) async throws -> BattleResult {
        struct Start: Encodable { let opponentUid: String? }
        return try await request("/api/battle/start", method: "POST", body: Start(opponentUid: opponentUid))
    }
    func fetchBattle(id: Int) async throws -> BattleResult { try await request("/api/battle/result/\(id)") }
    func fetchRanking(week: String, limit: Int = 50) async throws -> [RankingEntry] {
        try await request("/api/ranking?week=\(week)&limit=\(limit)", authorized: false)
    }
}


struct Empty: Decodable {}
