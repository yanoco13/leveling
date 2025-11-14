//
//  WinnerBadge.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//

import SwiftUI


struct WinnerBadge: View { let isYouWin: Bool
    var body: some View { Text(isYouWin ? "YOU WIN" : "OPP WIN").font(.caption).padding(.horizontal, 8).padding(.vertical, 4).background(Capsule().fill(isYouWin ? .green.opacity(0.2) : .red.opacity(0.2))) }
}
