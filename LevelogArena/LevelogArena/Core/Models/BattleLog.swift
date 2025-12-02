//
//  BattleLog.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//

import Foundation


struct BattleLog: Codable, Hashable, Identifiable {
    let turn: Int
    let actor: String
    let atk: Int
    let def: Int
    let dmg: Int
    let hpYou: Int
    let hpOpp: Int
    let note: String?
    var id: Int { turn * 10 + (actor == "you" ? 1 : 2) }
}
