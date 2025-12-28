import SwiftUI

/// 「今日の振り返り」画面
/// - 今日記録した行動のサマリ表示
/// - 新しい行動の入力
/// - 今日のログ一覧表示
struct TodayView: View {

    /// 全ログを管理する共有ストア
    /// App全体で EnvironmentObject として注入されている
    @EnvironmentObject var store: LogStore

    // 新規入力用のState
    @State private var title: String = ""                 // 行動のタイトル
    @State private var note: String = ""                  // メモ
    @State private var selectedCategory: LogEntry.Category? = nil   // カテゴリ（任意）

    private let calendar = Calendar.current

    var body: some View {
        // 今日の日付と同じ日のログだけを抽出
        let todayEntries = store.entries(onSameDayAs: Date())

        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {

                // 今日の行動数のサマリ表示
                summarySection(count: todayEntries.count)

                // 新しい行動の入力フォーム
                inputSection

                Divider().padding(.vertical, 4)

                // 今日のログ一覧のタイトル
                Text("今日のログ")
                    .font(.headline)
                    .padding(.horizontal)

                // 今日のログが無い場合
                if todayEntries.isEmpty {
                    Text("まだ記録がありません")
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                } else {
                    // 今日のログを一覧表示
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

    /// 今日何件行動を記録したかのサマリ表示
    @ViewBuilder
    private func summarySection(count: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("今日の達成")
                .font(.headline)

            // 件数を大きく表示
            Text("\(count) 件の行動を記録しました。")
                .font(.title3).bold()

            // 件数に応じたフィードバックメッセージ
            Text(feedbackText(for: count))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
        .padding(.top)
    }

    /// 行動数に応じた励ましメッセージを返す
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

    /// 新しい行動を記録するための入力UI
    private var inputSection: some View {
        GroupBox("新しい行動を記録") {
            VStack(alignment: .leading, spacing: 8) {

                // 行動のタイトル
                TextField("例）Swiftの勉強をした", text: $title)

                // 行動カテゴリ選択（任意）
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

                // 任意のメモ（複数行OK）
                TextField("メモ（任意）", text: $note, axis: .vertical)
                    .lineLimit(1...3)

                // 記録ボタン
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
                // タイトルが空のときは押せない
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.top, 4)
            }
        }
        .padding(.horizontal)
    }

    /// 入力内容を LogStore に保存してフォームをリセット
    private func addEntry() {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        store.addEntry(
            title: title,
            note: note.isEmpty ? nil : note,
            date: Date(),
            category: selectedCategory
        )

        // 入力欄をクリア
        title = ""
        note = ""
        selectedCategory = nil
    }
}

// MARK: - 行動ログ1件の表示行

/// 今日のログ一覧の1行分のUI
struct LogEntryRow: View {
    let entry: LogEntry

    /// 表示用の時刻フォーマッタ（HH:mm）
    private let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()

    var body: some View {
        HStack(alignment: .top, spacing: 8) {

            // 行動した時刻
            Text(timeFormatter.string(from: entry.date))
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 48, alignment: .leading)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    // カテゴリがあれば絵文字を表示
                    if let category = entry.category {
                        Text(category.emoji)
                    }

                    // 行動タイトル
                    Text(entry.title)
                        .font(.body)
                }

                // メモがあれば表示
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
