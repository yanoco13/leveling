//
//  StatPill.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//

import SwiftUI


struct StatPill: View { let label: String; let value: Int
    var body: some View { HStack { Text(label).bold(); Text("\(value)") }.padding(.horizontal, 10).padding(.vertical, 6).background(RoundedRectangle(cornerRadius: 12).strokeBorder(.separator)) }
}
