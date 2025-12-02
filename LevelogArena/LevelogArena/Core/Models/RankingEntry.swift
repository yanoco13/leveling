//
//  RankingEntry.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//

import Foundation


struct RankingEntry: Codable, Identifiable {
    let uid: String
    let winRate: Double
    let wins: Int
    let title: String
    var id: String { uid }
}
