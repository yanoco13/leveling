import SwiftUI
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var profile: Loadable<Profile> = .idle
    @Published var lastBattle: Loadable<BattleResult> = .idle
    @Published var toast: Toast? = nil

    let api: APIClient
    lazy var taskAPI = TaskAPI(api: api)

    // ✅ 追加：タイマー用ViewModel（アプリ全体で共有）
    lazy var timerVM = TaskTimerViewModel(taskAPI: taskAPI)

    init(api: APIClient) {
        self.api = api
    }

    func refreshProfile() async {
        profile = .loading
        do { profile = .loaded(try await api.fetchProfile()) }
        catch { profile = .failed(error) }
    }
}

enum Loadable<T> {
    case idle
    case loading
    case loaded(T)
    case failed(Error)
}

struct Toast: Identifiable {
    let id = UUID()
    let message: String
}
