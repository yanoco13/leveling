//
//  PrimaryButton.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//

import SwiftUI


struct PrimaryButton: View {
    let title: String
    var action: () -> Void
    var body: some View {
        Button(action: action) { Text(title).frame(maxWidth: .infinity).padding().bold() }
        .buttonStyle(.borderedProminent)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
