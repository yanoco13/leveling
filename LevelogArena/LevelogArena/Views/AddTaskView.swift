import SwiftUI

// -----------------------------
// タスク新規追加画面
// -----------------------------
// ・入力内容を元にタスクを新規作成するView
// ・保存ボタン押下時に「即時反映（Optimistic UI）」＋「サーバーPOST」を行う
struct AddTaskView: View {

    // sheet / Navigation を閉じるための環境値
    @Environment(\.dismiss) private var dismiss

    // -----------------------------
    // 画面入力用のローカルState
    // -----------------------------
    @State private var taskName = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var selectedItem = "力"
    @State private var inputMemo = ""

    // -----------------------------
    // 親Viewへ新規タスクを返すためのクロージャ
    // ・Optionalにしないことで「必ず親が受け取る」設計にしている
    // ・これが呼ばれると親の一覧が即時更新される
    // -----------------------------
    let onCreated: (TaskItem) -> Void

    var body: some View {
        NavigationStack {
            VStack {

                // 入力フォーム（共通コンポーネント）
                TaskForm(
                    taskName: $taskName,
                    startDate: $startDate,
                    endDate: $endDate,
                    selectedItem: $selectedItem,
                    inputMemo: $inputMemo
                )

                // -----------------------------
                // 追加ボタン
                // -----------------------------
                Button("追加") {

                    // ① まずは仮IDで TaskItem を作成（Optimistic UI）
                    //    id は List 差分更新のため必ずユニークにする
                    let optimistic = TaskItem(
                        id: -Int.random(in: 1...1_000_000), // 仮ID（負数）
                        title: taskName,
                        isDone: false,
                        startDate: startDate,
                        endDate: endDate,
                        category: selectedItem
                    )

                    // ② 親Viewへ即時反映
                    onCreated(optimistic)

                    // ③ サーバーへPOST（バックグラウンド）
                    postTask()

                    // ④ 画面を閉じる
                    dismiss()
                }
                .padding()

                // 何もせず閉じる
                Button("閉じる") {
                    dismiss()
                }
            }
            .navigationTitle("新規タスク")
        }
    }

    // -----------------------------
    // POST 用リクエストBody
    // -----------------------------
    struct InsertTaskRequest: Codable {
        let title: String
        let category: String
        let startDate: String
        let endDate: String
        let isDeleteFlg: Bool
        let isDone: Bool
    }

    // -----------------------------
    // Date → ISO8601 文字列変換
    // -----------------------------
    private func isoString(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: date)
    }

    // -----------------------------
    // タスク新規作成（POST）
    // -----------------------------
    private func postTask() {
        guard let url = URL(string: "http://localhost:8080/api/tasks") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // リクエストBodyを作成
        let body = InsertTaskRequest(
            title: taskName,
            category: selectedItem,
            startDate: isoString(startDate),
            endDate: isoString(endDate),
            isDeleteFlg: false,
            isDone: false
        )

        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in

            // 通信エラー
            if let error = error {
                print("POST エラー:", error)
                return
            }

            // HTTPステータス確認（デバッグ用）
            if let http = response as? HTTPURLResponse {
                print("POST status:", http.statusCode)
            }

            // -----------------------------
            // サーバーが TaskItem を返す場合
            // -----------------------------
            // 返却された正式な TaskItem（本ID）で
            // 親Viewの仮データを差し替える設計も可能
            if let data = data,
               let created = try? JSONDecoder().decode(TaskItem.self, from: data) {

                DispatchQueue.main.async {
                    onCreated(created)
                    dismiss()
                }

            } else {
                // -----------------------------
                // 返却がない / 形式が違う場合
                // -----------------------------
                // SSE や一覧再取得で後追い同期する前提
                DispatchQueue.main.async {
                    dismiss()
                }
            }
        }
        .resume()
    }
}
