//
//  Badge.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//

import SwiftUI


struct Badge: View { let text: String; var body: some View { Text(text).font(.caption).padding(.horizontal, 8).padding(.vertical, 4).background(Capsule().fill(.thinMaterial)) } }
