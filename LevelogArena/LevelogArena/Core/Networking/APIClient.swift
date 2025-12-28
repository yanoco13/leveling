import Foundation

extension APIClient {
    func fetchProfile() async throws -> Profile {
        try await request("/api/profile")
    }
}

extension APIClient {
    /// レスポンスボディが無いAPI向け
    func requestVoid(
        _ path: String,
        method: String = "POST",
        body: Encodable? = nil,
        authorized: Bool = true
    ) async throws {
        let _: Empty = try await request(path, method: method, body: body, authorized: authorized)
    }
}

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

    /// 共通リクエスト
    func request<T: Decodable>(
        _ path: String,
        method: String = "GET",
        body: Encodable? = nil,
        authorized: Bool = true
    ) async throws -> T {

        var url = baseURL
        url.append(path: path)

        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        // 認証が必要なら Firebase ID Token を Authorization に付ける
        let token = try await auth.getIDToken()
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        if let body {
            req.httpBody = try encoder.encode(AnyEncodable(body))
        }

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw URLError(.badServerResponse) }

        guard (200..<300).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? ""
            print("HTTP Error:", http.statusCode, body)
            throw URLError(.badServerResponse)
        }


        if T.self == Empty.self { return Empty() as! T }
        return try decoder.decode(T.self, from: data)
    }
}

struct AnyEncodable: Encodable {
    let value: Encodable
    init(_ value: Encodable) { self.value = value }
    func encode(to encoder: Encoder) throws { try value.encode(to: encoder) }
}

struct Empty: Decodable {}
