import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var store: LogStore

    @State private var currentMonth: Date = Date()
    @State private var selectedDate: Date? = nil

    private let calendar = Calendar.current
    private let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f
    }()
    private let monthFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy年 M月"
        return f
    }()

    var body: some View {
        NavigationStack {
            VStack {
                header

                let days = generateDays(for: currentMonth)

                // 曜日ヘッダー
                weekdayHeader

                // カレンダー本体（7列グリッド）
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 8) {
                    ForEach(days, id: \.self) { date in
                        dayCell(for: date)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("カレンダー")
            .sheet(item: Binding(
                get: { selectedDate.map(IdentifiedDate.init(date:)) },
                set: { selectedDate = $0?.date }
            )) { idDate in
                DayDetailSheet(date: idDate.date)
                    .environmentObject(store)
            }
        }
    }

    // MARK: - ヘッダー（月送り）

    private var header: some View {
        HStack {
            Button {
                changeMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Text(monthFormatter.string(from: currentMonth))
                .font(.title3)
                .bold()

            Spacer()

            Button {
                changeMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }

    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }

    // MARK: - 曜日ヘッダー

    private var weekdayHeader: some View {
        let symbols = calendar.shortWeekdaySymbols // ["Sun", "Mon", ...] 端末のロケール依存
        return HStack {
            ForEach(0..<7, id: \.self) { index in
                Text(symbols[(index + calendar.firstWeekday - 1) % 7])
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    // MARK: - 日セル表示

    @ViewBuilder
    private func dayCell(for date: Date) -> some View {
        let count = store.count(onSameDayAs: date)
        let isToday = calendar.isDateInToday(date)

        Button {
            if count > 0 {
                selectedDate = date
            }
        } label: {
            VStack(spacing: 4) {
                Text(dayFormatter.string(from: date))
                    .font(.body)
                    .foregroundColor(isToday ? .blue : .primary)

                if count > 0 {
                    Text("\(count)")
                        .font(.caption2)
                        .padding(4)
                        .background(
                            Circle()
                                .fill(Color.blue.opacity(0.15))
                        )
                } else {
                    // 何もしない or 薄いドットを表示してもOK
                    Circle()
                        .frame(width: 4, height: 4)
                        .opacity(0)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 40)
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isToday ? Color.blue : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - 月の日付一覧生成

    private func generateDays(for date: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else { return [] }

        var days: [Date] = []

        // 先頭の週をカレンダーの firstWeekday に揃える
        var current = monthInterval.start
        let weekday = calendar.component(.weekday, from: current)
        let diff = weekday - calendar.firstWeekday
        if diff > 0 {
            current = calendar.date(byAdding: .day, value: -diff, to: current) ?? current
        }

        // 6週間分くらい出しておく（ほぼ全部の月をカバー）
        for _ in 0..<42 {
            days.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }

        return days
    }

    // sheet 用のラッパー
    struct IdentifiedDate: Identifiable {
        let id = UUID()
        let date: Date
    }
}

// 日をタップしたときに出る詳細シート
struct DayDetailSheet: View {
    @EnvironmentObject var store: LogStore
    let date: Date

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy年 M月d日 (E)"
        return f
    }()

    var body: some View {
        NavigationStack {
            let entries = store.entries(onSameDayAs: date)

            VStack(alignment: .leading) {
                Text(dateFormatter.string(from: date))
                    .font(.headline)
                    .padding()

                if entries.isEmpty {
                    Text("この日は記録がありません。")
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    Spacer()
                } else {
                    List(entries) { entry in
                        LogEntryRow(entry: entry)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("1日の記録")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
