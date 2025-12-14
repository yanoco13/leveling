import SwiftUI

// -----------------------------
// タスク編集画面
// -----------------------------
// 親View（TaskView）の tasks 配列の1要素を
// Binding で受け取り、直接編集できるView
struct EditTaskView: View {

    // 画面を閉じるための環境値（sheet / Navigation どちらでも使える）
    @Environment(\.dismiss) private var dismiss

    // 親から渡された編集対象のタスク
    // Binding なので、ここで更新すると親の一覧にも即反映される
    @Binding var task: TaskItem

    // 画面入力用のローカルState
    // 直接 task を編集せず、一度 State に展開してから更新する
    @State private var taskName = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var selectedItem = "力"
    @State private var inputMemo = ""

    var body: some View {
        VStack {

            // 共通フォーム（入力UI部分）
            TaskForm(
                taskName: $taskName,
                startDate: $startDate,
                endDate: $endDate,
                selectedItem: $selectedItem,
                inputMemo: $inputMemo
            )

            // -----------------------------
            // 更新ボタン
            // -----------------------------
            Button("更新") {
                updateTask()
            }
            .padding()

            // 画面を閉じるだけ（保存しない）
            Button("閉じる") {
                dismiss()
            }
        }
        .navigationTitle("タスク編集")
        .onAppear {
            // -----------------------------
            // 親から渡された task の値を
            // 画面表示用 State にコピー
            // -----------------------------
            taskName = task.title
            startDate = task.startDate
            endDate = task.endDate
            selectedItem = task.category
            // inputMemo = task.memo ?? ""
        }
    }

    // -----------------------------
    // PUT 用リクエストBody
    // -----------------------------
    struct UpdateTaskRequest: Codable {
        let id: Int
        let title: String
        let category: String
        let startDate: String
        let endDate: String
        let isDone: Bool
    }

    // -----------------------------
    // Date → ISO8601文字列変換
    // -----------------------------
    private func isoString(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: date)
    }

    // -----------------------------
    // タスク更新（PUT）
    // -----------------------------
    private func updateTask() {
        let id = task.id
        guard let url = URL(string: "http://localhost:8080/api/tasks/\(id)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // 更新内容をリクエストBodyに詰める
        let body = UpdateTaskRequest(
            id: id,
            title: taskName,
            category: selectedItem,
            startDate: isoString(startDate),
            endDate: isoString(endDate),
            isDone: task.isDone ?? false
        )

        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            // 通信エラー
            if let error = error {
                print("PUT エラー:", error)
                return
            }

            // HTTPステータス確認（デバッグ用）
            if let http = response as? HTTPURLResponse {
                print("PUT status:", http.statusCode)
            }

            // -----------------------------
            // 成功時の処理
            // -----------------------------
            // 親Viewの Binding<TaskItem> を更新
            // → TaskView の一覧も自動で更新される
            DispatchQueue.main.async {
                task.title = taskName
                task.startDate = startDate
                task.endDate = endDate
                task.category = selectedItem
                // task.memo = inputMemo

                // 編集完了後に画面を閉じる
                dismiss()
            }
        }
        .resume()
    }
}
