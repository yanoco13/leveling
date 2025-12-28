import SwiftUI

/// 履歴（History）画面
/// - 月ごとのカレンダーを表示
/// - 今後ここに「完了タスク」や「行動ログ」を重ねて表示していく想定
struct HistoryView: View {

    /// 表示中の月（初期値は現在の月）
    @State private var currentMonth: Date = Date()

    /// 日付計算に使うカレンダー
    private let calendar = Calendar.current

    /// カレンダーの各マスに表示する「日」用フォーマッタ
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d"   // 1, 2, 3, ... のように日だけ表示
        return f
    }()

    var body: some View {
        VStack {

            // MARK: - 月切り替えヘッダー
            HStack {

                // 前の月へ
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }

                Spacer()

                // 現在表示している月（例: 2025年 2月）
                Text(monthTitle(from: currentMonth))
                    .font(.title)

                Spacer()

                // 次の月へ
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            .padding(.top)

            // MARK: - カレンダー本体

            // 現在の月に含まれるすべての日付を生成
            let days = generateDays(for: currentMonth)

            // 7列のグリッド = 1週間分のカレンダー
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(days, id: \.self) { date in

                    // 各日の数字（1〜31）を表示
                    Text(dateFormatter.string(from: date))
                        .frame(maxWidth: .infinity, minHeight: 40)
                }
            }
        }
    }

    // MARK: - 月送り操作

    /// 現在の月を前後に移動する
    /// - value: -1 で前月、+1 で翌月
    func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }

    // MARK: - 月タイトル（例：2025年 2月）

    /// Date から「yyyy年 M月」形式の文字列を作る
    func monthTitle(from date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy年 M月"
        return f.string(from: date)
    }

    // MARK: - 指定月の日リスト生成

    /// 指定した月に含まれるすべての日付を配列で返す
    /// 例）2025年2月 → 2/1, 2/2, ..., 2/28
    func generateDays(for date: Date) -> [Date] {
        guard let interval = calendar.dateInterval(of: .month, for: date) else { return [] }

        var days: [Date] = []
        var current = interval.start

        // 月の開始日から終了日まで1日ずつ追加
        while current < interval.end {
            days.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }

        return days
    }
}
