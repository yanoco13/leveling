import SwiftUI

struct TodayView: View {
    @EnvironmentObject var store: LogStore
    @State private var title: String = ""
    @State private var note: String = ""
    @State private var selectedCategory: LogEntry.Category? = nil

    private let calendar = Calendar.current

    var body: some View {
        let todayEntries = store.entries(onSameDayAs: Date())

        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {

                // 今日のサマリ
                summarySection(count: todayEntries.count)

                // 入力フォーム
                inputSection

                Divider().padding(.vertical, 4)

                // 今日のログ一覧
                Text("今日のログ")
                    .font(.headline)
                    .padding(.horizontal)

                if todayEntries.isEmpty {
                    Text("まだ記録がありません")
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                } else {
                    List(todayEntries) { entry in
                        LogEntryRow(entry: entry)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("今日の振り返り")
        }
    }

    // MARK: - 今日のサマリ

    @ViewBuilder
    private func summarySection(count: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("今日の達成")
                .font(.headline)

            Text("\(count) 件の行動を記録しました。")
                .font(.title3).bold()

            Text(feedbackText(for: count))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
        .padding(.top)
    }

    private func feedbackText(for count: Int) -> String {
        switch count {
        case 0:
            return "まずは 1 件からはじめてみましょう。小さな一歩が大事です。"
        case 1...3:
            return "いいスタートです。今日やったことをしっかり覚えておきましょう。"
        case 4...7:
            return "かなり動けていますね！自分を褒めてあげてください 👏"
        default:
            return "すごい行動量です！オーバーワークには気をつけつつ、よく頑張りました。"
        }
    }

    // MARK: - 入力フォーム

    private var inputSection: some View {
        GroupBox("新しい行動を記録") {
            VStack(alignment: .leading, spacing: 8) {
                TextField("例）Swiftの勉強をした", text: $title)

                Picker("カテゴリ", selection: Binding(
                    get: { selectedCategory ?? .other },
                    set: { selectedCategory = $0 }
                )) {
                    Text("未選択").tag(LogEntry.Category.other)
                    ForEach(LogEntry.Category.allCases) { category in
                        Text("\(category.emoji) \(category.label)")
                            .tag(category)
                    }
                }
                .pickerStyle(.menu)

                TextField("メモ（任意）", text: $note, axis: .vertical)
                    .lineLimit(1...3)

                Button {
                    addEntry()
                } label: {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("記録する")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.top, 4)
            }
        }
        .padding(.horizontal)
    }

    private func addEntry() {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        store.addEntry(
            title: title,
            note: note.isEmpty ? nil : note,
            date: Date(),
            category: selectedCategory
        )
        title = ""
        note = ""
        selectedCategory = nil
    }
}

// 行動ログ1件の表示行
struct LogEntryRow: View {
    let entry: LogEntry
    private let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // 時刻
            Text(timeFormatter.string(from: entry.date))
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 48, alignment: .leading)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    if let category = entry.category {
                        Text(category.emoji)
                    }
                    Text(entry.title)
                        .font(.body)
                }

                if let note = entry.note, !note.isEmpty {
                    Text(note)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
