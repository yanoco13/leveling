//
//  TaskCompleteResponse.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//
import SwiftUI
import Foundation


struct TaskCompleteResponse: Codable {
    var gainedAttr: String
    var gainedPt: Int
    var totals: Attributes
    var logId: Int
}
