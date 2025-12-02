//
//  LevelogArenaApp.swift
//  LevelogArena
//

import SwiftUI

@main
struct LevelogArenaApp: App {
    @StateObject private var state = AppState(api: APIClient())


    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack { TaskView() }.tabItem { Label("Task", systemImage: "list.bullet") }
                NavigationStack { ArenaView() }.tabItem { Label("Home", systemImage: "house.fill") }
                NavigationStack { RankingView() }.tabItem { Label("Setting", systemImage: "gearshape.fill") }
            }
            .environmentObject(state)
                .toast($state.toast)
        }
    }
}
