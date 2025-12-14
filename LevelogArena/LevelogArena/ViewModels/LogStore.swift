import Foundation
import Combine

final class LogStore: ObservableObject {
    @Published var entries: [LogEntry] = []

    private let calendar = Calendar.current

    // 行動ログを追加
    func addEntry(
        title: String,
        note: String?,
        date: Date = Date(),
        category: LogEntry.Category?
    ) {
        let entry = LogEntry(
            date: date,
            title: title,
            note: note,
            durationMinutes: nil,
            category: category
        )
        entries.append(entry)
    }

    // 指定日のエントリ一覧
    func entries(onSameDayAs date: Date) -> [LogEntry] {
        entries
            .filter { calendar.isDate($0.date, inSameDayAs: date) }
            .sorted { $0.date > $1.date }
    }

    // カレンダー表示用：各日の件数
    func count(onSameDayAs date: Date) -> Int {
        entries(onSameDayAs: date).count
    }
}

// 日別グルーピング（今後「過去の一覧」画面を作るときに便利）
extension Collection where Element == LogEntry {
    func groupedByDay(calendar: Calendar = .current)
    -> [(date: Date, entries: [LogEntry])] {

        let grouped = Dictionary(grouping: self) { calendar.startOfDay(for: $0.date) }

        return grouped
            .sorted { $0.key > $1.key } // 新しい日付が上
            .map { (date: $0.key,
                    entries: $0.value.sorted { $0.date > $1.date }) }
    }
}

extension LogStore {

    /// 指定日に完了したタスク一覧
    func doneTaskEntries(onSameDayAs date: Date) -> [LogEntry] {
        entries
            .filter { $0.category == .doneTask }
            .filter { calendar.isDate($0.date, inSameDayAs: date) }
            .sorted { $0.date > $1.date }
    }

    /// カレンダー表示用：完了タスク数
    func doneTaskCount(onSameDayAs date: Date) -> Int {
        doneTaskEntries(onSameDayAs: date).count
    }
}
