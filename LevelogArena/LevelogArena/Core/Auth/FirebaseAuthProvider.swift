//
//  FirebaseAuthProvider.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//

import Foundation
#if canImport(FirebaseAuth)
import FirebaseAuth
final class FirebaseAuthProvider: AuthProvider {
    func getIDToken() async throws -> String? {
        try await withCheckedThrowingContinuation { cont in
            Auth.auth().currentUser?.getIDToken(completion: { token, err in
                if let err = err { cont.resume(throwing: err); return }
                cont.resume(returning: token)
            })
        }
    }
}
#endif
