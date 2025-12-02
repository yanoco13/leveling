//
//  ErrorView.swift
//  LevelogArena
//


import SwiftUI


struct ErrorView: View {
    let error: Error
    var retry: () -> Void
    var body: some View {
        VStack(spacing: 12) {
            Text("Error").font(.headline)
            Text(error.localizedDescription).font(.caption).multilineTextAlignment(.center)
            PrimaryButton(title: "Retry", action: retry)
        }.padding()
    }
}
