//
//  AuthProvider.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//

import Foundation


protocol AuthProvider {
    func getIDToken() async throws -> String?
}
