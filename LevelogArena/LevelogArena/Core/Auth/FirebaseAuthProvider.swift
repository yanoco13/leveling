import Foundation
import FirebaseAuth

/// APIClient が「IDトークンを取る」ための抽象
protocol AuthProvider {
    func getIDToken() async throws -> String?
}

/// FirebaseAuth から IDトークン（JWT）を取得する AuthProvider
final class FirebaseAuthProvider: AuthProvider {
    func getIDToken() async throws -> String? {
        guard let user = Auth.auth().currentUser else { return nil }
        return try await user.getIDToken()
    }
}

/// 開発用（トークン無し）
final class MockAuthProvider: AuthProvider {
    func getIDToken() async throws -> String? { nil }
}
