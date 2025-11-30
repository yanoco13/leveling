import SwiftUI

// モーダル画面（新規タスク追加画面）
struct SecondView: View {
    // モーダルを閉じるための環境変数
    @Environment(\.dismiss) private var dismiss
    
    // 開始日
    @State var startDate = Date()
    // 終了日
    @State var endDate = Date()

    // カテゴリー選択
    @State var selectedItem = "Apple"
    let items = ["Apple", "Orange", "Banana"] // 仮のカテゴリ一覧（テスト用）

    // タスク名
    @State var taskName = ""
    // メモ
    @State var inputMemo = ""

    var body: some View {
        NavigationStack {
            VStack {
                // タスク名入力欄
                TextField(TaskConstants.MESSAGE_INPUT_TASK_NAME, text: $taskName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                // 開始日入力
                DatePicker(
                    TaskConstants.MESSAGE_INPUT_START_DATE,
                    selection: $startDate,
                    displayedComponents: [.date]
                )
                .padding()
                
                // 終了日入力
                DatePicker(
                    TaskConstants.MESSAGE_INPUT_END_DATE,
                    selection: $endDate,
                    displayedComponents: [.date]
                )
                .padding()
                
                // カテゴリ選択（Picker）
                Picker("選択", selection: $selectedItem) {
                    ForEach(items, id: \.self) { item in
                        Text(item).tag(item)
                    }
                }
                .pickerStyle(.menu)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                
                // メモ入力欄
                TextField(TaskConstants.MESSAGE_INPUT_MEMO, text: $inputMemo)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                // 追加ボタン
                Button("追加") {
                    postTask()  // API へ POST
                    dismiss()   // 追加後モーダルを閉じる
                }
                .padding()
                
                // 閉じるボタン
                Button("閉じる") {
                    dismiss()
                }
            }
            // 画面タイトル
            .navigationTitle(TaskConstants.TITLE_ADD_TASK)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // -----------------------------
    // API タスクを追加する POST 関数
    // -----------------------------
    func postTask() {
        let url = URL(string: "http://localhost:8080/api/tasks")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // JSON を送信するヘッダ
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Date → ISO8601 文字列に変換
        let start = isoString(startDate)
        let end   = isoString(endDate)

        // API に送るリクエストボディ
        let body = TaskRequest(
            title: taskName,        // 入力されたタスク名
            category: selectedItem, // Picker の選択
            startDate: start,       // 開始日
            endDate: end            // 終了日
        )
        
        // JSONEncoder でエンコードしてボディにセット
        request.httpBody = try! JSONEncoder().encode(body)
        
        // 非同期通信開始
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // 通信エラー時
            if let error = error {
                print("通信エラー:", error)
                return
            }
            
            // ステータスコード確認（200 など）
            if let http = response as? HTTPURLResponse {
                print("status:", http.statusCode)
            }
            
            // レスポンスボディをログに出力
            if let data = data {
                print("レスポンス:", String(data: data, encoding: .utf8)!)
            }
            
        }.resume() // 通信開始
    }
}


// -----------------------------
// API 送信する JSON ボディ用 Struct
// -----------------------------
struct TaskRequest: Codable {
    let title: String
    let category: String
    let startDate: String   // 例: "2025-11-24"
    let endDate: String     // 例: "2025-11-25"
}


// -----------------------------
// Date ↔ ISO8601 String の変換
// -----------------------------
func parseDate(_ iso: String) -> Date? {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    return formatter.date(from: iso)
}

func isoString(_ date: Date) -> String {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    return formatter.string(from: date)
}
