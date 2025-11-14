//
//  RankingView.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//

import SwiftUI


struct RankingView: View {
    @State private var weekISO = Self.defaultWeek()
    @State private var entries: [RankingEntry] = []
    @State private var loading = false
    @EnvironmentObject var state: AppState


    var body: some View {
        List {
            Section(header: picker) {
                if loading { ProgressView() }
                ForEach(entries) { e in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(e.uid).font(.callout).bold()
                            Text(e.title).font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("WinRate \(Int(e.winRate * 100))%")
                            Text("\(e.wins) wins").font(.caption)
                        }
                    }
                }
            }
        }
        .navigationTitle("Ranking")
        .task { await load() }
    }


    @ViewBuilder var picker: some View {
        HStack { Text("Week"); Spacer(); Text(weekISO).monospaced() }.onTapGesture { Task { await load() } }
    }


    static func defaultWeek() -> String {
        let cal = Calendar(identifier: .iso8601)
        let now = Date()
        let y = cal.component(.yearForWeekOfYear, from: now)
        let w = cal.component(.weekOfYear, from: now)
        return String(format: "%04d-W%02d", y, w)
    }


    private func load() async {
        loading = true; defer { loading = false }
        do { entries = try await state.api.fetchRanking(week: weekISO) } catch { entries = []; state.toast = Toast(message: error.localizedDescription) }
    }
}
