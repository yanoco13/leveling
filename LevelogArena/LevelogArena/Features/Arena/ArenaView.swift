//
//  ArenaView.swift
//  LevelogArena
//

import SwiftUI
//
//
//enum Route: Hashable {
//    case arena
//    case battle(Int)  // battleId のみ
//    case ranking
//}
//
//
//struct ArenaView: View {
//    @EnvironmentObject var state: AppState
//    var body: some View {
//        VStack(spacing: 16) {
//            PrimaryButton(title: "Find Opponent & Start") { Task { await state.startBattle() } }
//            content
//        }
//        .padding()
//        .navigationTitle("Arena")
//    }
//
//
//    @ViewBuilder var content: some View {
//        switch state.lastBattle {
//            case .idle: EmptyView()
//            case .loading: ProgressView()
//            case .failed(let e): ErrorView(error: e) { Task { await state.startBattle() } }
//            case .loaded(let r): BattleLogView(result: r)
//        }
//    }
//}

struct ArenaView: View {
    @State private var animationName = "hero_idle"

    var body: some View {
        VStack(spacing: 24) {
            Text("⚔️ Arena Battle")
                .font(.title.bold())

            CharacterView(animationName: animationName)

            HStack(spacing: 16) {
                Button("Idle") { animationName = "hero_idle" }
                    .buttonStyle(.borderedProminent)
            }

            Spacer()
        }
        .padding()
        .animation(.easeInOut, value: animationName)
    }
}
