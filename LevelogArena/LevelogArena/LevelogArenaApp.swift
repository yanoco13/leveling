import SwiftUI
import FirebaseCore
import FirebaseAuth

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()

        // ログイン画面なしで使う：匿名ログインを起動時に保証
        Task {
            do {
                if Auth.auth().currentUser == nil {
                    _ = try await Auth.auth().signInAnonymously()
                    print("Signed in anonymously:", Auth.auth().currentUser?.uid ?? "nil")
                }
            } catch {
                print("Anonymous sign-in failed:", error)
            }
        }
        return true
    }
}

@main
struct LevelogArenaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    /// ✅ APIClientには FirebaseAuthProvider を入れる（Authorizationが付く）
    @StateObject private var state = AppState(api: APIClient(auth: FirebaseAuthProvider()))
    @StateObject private var logStore = LogStore()

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack { TaskView() }.tabItem { Label("Task", systemImage: "list.bullet") }
                NavigationStack { HomeView() }.tabItem { Label("Home", systemImage: "house.fill") }
                NavigationStack { HistoryView() }.tabItem { Label("History", systemImage: "calendar") }
                NavigationStack { TodayView() }.tabItem { Label("Today", systemImage: "sun.max") }
                NavigationStack { CalendarView() }.tabItem { Label("Calendar", systemImage: "calendar") }
            }
            .environmentObject(state)
            .environmentObject(logStore)
            .toast($state.toast)
        }
    }
}
