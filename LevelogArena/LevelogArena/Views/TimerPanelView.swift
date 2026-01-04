//
//  TimerPanelView.swift
//  LevelogArena
//
//  Created by 矢野遼 on 2026/01/04.
//


import SwiftUI

struct TimerPanelView: View {
    @EnvironmentObject private var state: AppState
    let taskId: Int

    var body: some View {
        VStack(spacing: 12) {
            Text(state.timerVM.elapsedText)
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .monospacedDigit()

            HStack(spacing: 12) {
                Button {
                    Task { await state.timerVM.start(taskId: taskId) }
                } label: {
                    Label("開始", systemImage: "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(state.timerVM.isLoading || state.timerVM.isRunning)

                Button {
                    Task { await state.timerVM.stop() }
                } label: {
                    Label("停止", systemImage: "stop.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(state.timerVM.isLoading || !state.timerVM.isRunning)
            }

            if state.timerVM.isRunning, let s = state.timerVM.runningSession {
                Text("開始: \(s.startedAt.formatted(date: .abbreviated, time: .standard))")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
