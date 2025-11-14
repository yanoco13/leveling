//
//  BattleLogView.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//

import SwiftUI


struct BattleLogView: View {
    let result: BattleResult
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack { Text("Battle #\(result.battleId)").bold(); Spacer(); WinnerBadge(isYouWin: result.winner == result.attacker) }
            ForEach(result.log) { entry in
                    HStack(alignment: .top, spacing: 12) {
                        Text("T\(entry.turn)").monospaced().frame(width: 28)
                        VStack(alignment: .leading) {
                            Text("\(entry.actor.uppercased()) atk \(entry.atk) → dmg \(entry.dmg)")
                            Text("YOU: \(entry.hpYou) OPP: \(entry.hpOpp)").font(.caption).foregroundStyle(.secondary)
                            if let note = entry.note { Text(note).font(.caption2).italic() }
                        }
                        Spacer()
                }
            }
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(.separator))
    }
}
