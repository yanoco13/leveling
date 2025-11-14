//
//  BattleResult.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//
import Foundation


struct BattleResult: Codable, Identifiable, Hashable {
    let battleId: Int
    let attacker: String
    let defender: String
    let winner: String
    let log: [BattleLog]
    let createdAt: Date

    var id: Int { battleId }
}



