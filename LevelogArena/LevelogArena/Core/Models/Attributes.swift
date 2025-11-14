//
//  Attributes.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//
import SwiftUI
import Foundation


struct Attributes: Codable, Hashable, DefaultInitializable {
    var str: Int
    var int: Int
    var vit: Int
    static var `default`: Attributes { Attributes(str: 0, int: 0, vit: 0) }
}
