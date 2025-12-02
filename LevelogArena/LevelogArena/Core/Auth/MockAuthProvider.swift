//
//  MockAuthProvider.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//

import Foundation


final class MockAuthProvider: AuthProvider {
    func getIDToken() async throws -> String? { nil }
}
