//
//  Profile.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//
import SwiftUI
import Foundation


struct Profile: Codable, Hashable, Identifiable, DefaultInitializable {
    var uid: String
    var displayName: String
    var level: Int
    var title: String
    var attributes: Attributes
    var today: Attributes
    var id: String { uid }
    static var `default`: Profile { .init(uid: "", displayName: "", level: 1, title: "Novice", attributes: .default, today: .default) }
}
