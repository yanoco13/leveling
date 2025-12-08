import SwiftUI

struct HistoryView: View {
    @State private var currentMonth: Date = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f
    }()
    
    var body: some View {
        VStack {
            // 月のタイトル + 送りボタン
            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Spacer()
                
                Text(monthTitle(from: currentMonth))
                    .font(.title)
                
                Spacer()
                
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // カレンダー本体
            let days = generateDays(for: currentMonth)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(days, id: \.self) { date in
                    Text(dateFormatter.string(from: date))
                        .frame(maxWidth: .infinity, minHeight: 40)
                }
            }
        }
    }
    
    
    // MARK: - 月送り操作
    func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    
    // MARK: - 月タイトル（例：2025年 2月）
    func monthTitle(from date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy年 M月"
        return f.string(from: date)
    }
    
    
    // MARK: - 指定月の日リスト生成
    func generateDays(for date: Date) -> [Date] {
        guard let interval = calendar.dateInterval(of: .month, for: date) else { return [] }
        var days: [Date] = []
        var current = interval.start
        
        while current < interval.end {
            days.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }
        
        return days
    }
}
