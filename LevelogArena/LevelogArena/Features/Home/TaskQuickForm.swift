//
//  TaskQuickForm.swift
//  LevelogArena
//

import SwiftUI


struct TaskQuickForm: View {
    @EnvironmentObject var state: AppState
    @State private var category: String = "vitality"
    @State private var minutes: Int = 20
    @State private var intensity: String = "mid"
    @State private var inFlight = false


    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Complete a Task").font(.headline)
            Picker("Category", selection: $category) {
                Text("STR").tag("strength")
                Text("INT").tag("intelligence")
                Text("VIT").tag("vitality")
            }.pickerStyle(.segmented)
            Stepper(value: $minutes, in: 1...300) { Text("Minutes: \(minutes)") }
            Picker("Intensity", selection: $intensity) {
                Text("Low").tag("low"); Text("Mid").tag("mid"); Text("High").tag("high")
            }.pickerStyle(.segmented)
            PrimaryButton(title: inFlight ? "Sending..." : "Send") { Task { await send() } }.disabled(inFlight)
            Text("※ 送信成功でプロフィールが更新されます").font(.footnote).foregroundStyle(.secondary)
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(.separator))
    }


    private func send() async {
        guard !inFlight else { return }
        inFlight = true
        defer { inFlight = false }
        let req = TaskCompleteRequest(category: category, minutes: minutes, intensity: intensity, completedAt: Date())
        do {
            _ = try await state.api.completeTask(req)
            await state.refreshProfile()
            state.toast = Toast(message: "+\(intensity.uppercased()) \(minutes)m sent")
        } catch { state.toast = Toast(message: error.localizedDescription) }
    }
}
