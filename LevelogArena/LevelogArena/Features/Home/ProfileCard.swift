//
//  ProfileCard.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//

import SwiftUI


struct ProfileCard: View {
    let profile: Profile
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack { Text(profile.displayName).font(.title2).bold(); Spacer(); Badge(text: profile.title) }
            HStack(spacing: 12) {
                StatPill(label: "STR", value: profile.attributes.str)
                StatPill(label: "INT", value: profile.attributes.int)
                StatPill(label: "VIT", value: profile.attributes.vit)
            }
            Divider()
            Text("Today").font(.footnote).foregroundStyle(.secondary)
            HStack(spacing: 12) {
                StatPill(label: "+STR", value: profile.today.str)
                StatPill(label: "+INT", value: profile.today.int)
                StatPill(label: "+VIT", value: profile.today.vit)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(.separator))
    }
}
