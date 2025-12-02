//
//  AppState.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2025/11/03.
//

import SwiftUI
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var profile: Loadable<Profile> = .idle
    @Published var lastBattle: Loadable<BattleResult> = .idle
    @Published var toast: Toast? = nil

    let api: APIClient

    init(api: APIClient) { self.api = api }

    func refreshProfile() async {
        profile = .loading
        do { profile = .loaded(try await api.fetchProfile()) }
        catch { profile = .failed(error) }
    }

    func startBattle() async {
        lastBattle = .loading
        do { lastBattle = .loaded(try await api.startBattle()) }
        catch { lastBattle = .failed(error) }
    }
}


enum Loadable<T> {
    case idle
    case loading
    case loaded(T)
    case failed(Error)
}


struct Toast: Identifiable { let id = UUID(); let message: String }
