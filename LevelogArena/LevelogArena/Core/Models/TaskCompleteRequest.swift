//
//  TaskCompleteRequest.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//
import SwiftUI
import Foundation


struct TaskCompleteRequest: Codable {
    var category: String // strength|intelligence|vitality
    var minutes: Int // 1..300
    var intensity: String // low|mid|high
    var completedAt: Date
}
