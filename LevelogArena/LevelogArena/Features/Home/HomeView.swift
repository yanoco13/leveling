//
//  HomeView.swift
//  LevelogArena
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var state: AppState
    var body: some View {
        NavigationStack {
            content
            .navigationTitle("Levelog Arena")
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Refresh") { Task { await state.refreshProfile() } } } }
            .task { if case .idle = state.profile { await state.refreshProfile() } }
        }
    }


    @ViewBuilder var content: some View {
        switch state.profile {
            case .idle, .loading:
            ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .failed(let error):
            ErrorView(error: error) { Task { await state.refreshProfile() } }
            case .loaded(let p):
            ScrollView {
                VStack(spacing: 16) {
                    ProfileCard(profile: p)
                    TaskQuickForm()
                    NavigationLink(value: Route.arena) { PrimaryButton(title: "Start Battle", action: {}) }
                }.padding()
            }
        }
    }
}
