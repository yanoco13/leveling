import Foundation
import SwiftUI
import Combine

@MainActor
final class TaskTimerViewModel: ObservableObject {
    @Published var runningSession: TaskSession? = nil
    @Published var elapsedText: String = "00:00:00"
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private var timer: Timer?
    private let taskAPI: TaskAPI

    init(taskAPI: TaskAPI) {
        self.taskAPI = taskAPI
    }

    var isRunning: Bool { runningSession?.endedAt == nil && runningSession != nil }

    func onAppear() {
        // アプリ起動/画面復帰時に「走ってるセッション」を取りにいく（任意だがおすすめ）
        Task { await restoreRunningSessionIfAny() }
    }

    func onDisappear() {
        timer?.invalidate()
        timer = nil
    }

    func start(taskId: Int) async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        do {
            let session = try await taskAPI.startSession(taskId: taskId)
            runningSession = session
            startTicking()
        } catch {
            errorMessage = "開始に失敗しました: \(error)"
        }
        isLoading = false
    }

    func stop() async {
        guard let session = runningSession else { return }
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        do {
            let stopped = try await taskAPI.stopSession(sessionId: session.id)
            runningSession = stopped
            stopTicking()
            // 停止後は durationSec が確定して返ってくる想定
            elapsedText = format(seconds: stopped.durationSec)
        } catch {
            errorMessage = "停止に失敗しました: \(error)"
        }
        isLoading = false
    }

    func restoreRunningSessionIfAny() async {
        // running が無い場合は 404 を返す仕様なら、ここは握りつぶしてOK
        do {
            let running = try await taskAPI.fetchRunningSession()
            // 画面が「特定タスク」なら taskId で絞るのもあり（好み）
            runningSession = running
            startTicking()
        } catch {
            // 走ってないだけなら無視
        }
    }

    private func startTicking() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.updateElapsed()
        }
        updateElapsed()
    }

    private func stopTicking() {
        timer?.invalidate()
        timer = nil
    }

    private func updateElapsed() {
        guard let s = runningSession else {
            elapsedText = "00:00:00"
            return
        }

        if let ended = s.endedAt {
            // 停止済み
            let sec = max(0, Int(ended.timeIntervalSince(s.startedAt)))
            elapsedText = format(seconds: sec)
        } else {
            // 実行中：startedAt から差分で表示（バックグラウンド復帰してもズレない）
            let sec = max(0, Int(Date().timeIntervalSince(s.startedAt)))
            elapsedText = format(seconds: sec)
        }
    }

    private func format(seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
}
