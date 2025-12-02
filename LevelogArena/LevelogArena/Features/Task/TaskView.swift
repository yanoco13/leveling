import SwiftUI

// タスクの要素
struct Todo: Identifiable, Codable {
    let id = UUID()          // 一意のID（List表示で必須）
    var title: String        // タスク名
    var isDone: Bool? = false // 完了フラグ（APIにない場合もあるため Optional）
}

// タスク画面（一覧画面）
struct TaskView: View {
    @State private var todos: [Todo] = []     // 取得したタスク一覧
    @State private var newTodoText: String = "" // 未使用：新規タスク名（将来用）
    @State private var showModal = false      // モーダル表示フラグ

    var body: some View {
        VStack {
            // タスク追加ボタン（押すとモーダルを開く）
            Button(TaskConstants.MESSAGE_ADD_TASK) {
                showModal = true
            }
            .padding()
        }

        // モーダル表示（showModal が true で SecondView を開く）
        .sheet(isPresented: $showModal) {
            SecondView()  // 新規タスク追加画面
        }

        // タスク一覧を表示する List
        List(todos) { oneTodo in
            Text(oneTodo.title)
        }

        // 画面表示時に API からデータ取得
        .onAppear {
            loadData()
        }
    }

    // ----------------------------------------
    // 非同期で API から task 一覧を取得する関数
    // ----------------------------------------
    func loadData() {
        // URL が正しいかチェック
        guard let url = URL(string: "http://localhost:8080/api/tasks") else {
            print("URLが不正です")
            return
        }

        // GET リクエスト生成
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // 非同期通信
        URLSession.shared.dataTask(with: request) { data, response, error in

            // 通信エラー時
            if let error = error {
                print("エラー: \(error)")
                return
            }

            // データがない場合
            guard let data = data else {
                print("データなし")
                return
            }

            do {
                // JSON → Todo配列 にデコード
                let decoder = JSONDecoder()
                let fetchedTodos = try decoder.decode([Todo].self, from: data)

                // UI 更新はメインスレッドで実行
                DispatchQueue.main.async {
                    self.todos = fetchedTodos
                }

            } catch {
                // デコード失敗時
                print("JSON変換エラー: \(error)")
            }
        }
        .resume() // 通信開始
    }
}
