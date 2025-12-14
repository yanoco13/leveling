import SwiftUI

@main
struct LevelogArenaApp: App {
    @StateObject private var state = AppState(api: APIClient())
    @StateObject private var logStore = LogStore()   // ← 追加！

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
            .environmentObject(logStore)   // ← 必ずここで渡す！
            .toast($state.toast)
        }
    }
}
