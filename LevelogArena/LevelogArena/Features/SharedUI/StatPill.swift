//
//  StatPill.swift
//  LevelogArena
//

import SwiftUI


struct StatPill: View { let label: String; let value: Int
    var body: some View { HStack { Text(label).bold(); Text("\(value)") }.padding(.horizontal, 10).padding(.vertical, 6).background(RoundedRectangle(cornerRadius: 12).strokeBorder(.separator)) }
}
