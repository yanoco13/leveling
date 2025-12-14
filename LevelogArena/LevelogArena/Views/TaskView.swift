import SwiftUI

struct TaskView: View {
    // ✅ LogStore を使うので必要
    @EnvironmentObject var store: LogStore

    @State private var tasks: [TaskItem] = []
    @State private var showAddModal = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Button(TaskConstants.MESSAGE_ADD_TASK) {
                    showAddModal = true
                }
                .padding()

                List {
                    // ✅ isDone == true は表示しない（Bindingを維持したままfilter）
                    ForEach($tasks.filter { !$0.wrappedValue.isDone && !$0.wrappedValue.isDeleteFlg}) { $task in
                        NavigationLink(destination: EditTaskView(task: $task)) {
                            Text(task.title)
                                .draggable(String(task.id))
                        }
                    }
                }
            }
            HStack(spacing: 24) {
                VStack {
                    DoneDropZone { droppedId in
                        markDoneAndSync(id: droppedId)
                    }
                    Text("Done")
                        .font(.caption2)
                }

                VStack {
                    DeleteDropZone { droppedId in
                        markDeleteAndSync(id: droppedId)
                    }
                    Text("削除")
                        .font(.caption2)
                }
            }
            .sheet(isPresented: $showAddModal, onDismiss: {
                loadData()
            }) {
                AddTaskView { created in
                    tasks.insert(created, at: 0)
                }
            }
            .onAppear {
                loadData()
            }
        }
    }

    func loadData() {
        guard let url = URL(string: "http://localhost:8080/api/tasks") else {
            print("URL不正")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("通信エラー:", error)
                return
            }
            guard let data = data else {
                print("データなし")
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let fetched = try decoder.decode([TaskItem].self, from: data)

                DispatchQueue.main.async {
                    self.tasks = fetched
                }
            } catch {
                print("JSON デコードエラー:", error)
            }
        }
        .resume()
    }

    private func markDoneAndSync(id: Int) {
        guard let idx = tasks.firstIndex(where: { $0.id == id }) else { return }
        let before = tasks[idx]

        // ① UI即時反映
        tasks[idx].isDone = true

        // ② 完了ログを記録（カレンダー表示用）
        // ※ title/category は「完了にしたタスク」を使う
        store.addEntry(
            title: before.title,
            note: "カテゴリ: \(before.category)",
            date: Date(),
            category: .doneTask
        )

        // ③ サーバーへPUT（失敗ならロールバック）
        Task {
            do {
                try await putTaskDone(task: tasks[idx])
            } catch {
                print("done更新失敗:", error)
                await MainActor.run {
                    tasks[idx] = before
                }
            }
        }
    }
    
    private func markDeleteAndSync(id: Int) {
        guard let idx = tasks.firstIndex(where: { $0.id == id }) else { return }
        let before = tasks[idx]

        // ① UI即時反映（一覧から消える）
        tasks[idx].isDeleteFlg = true

        // ② サーバーへ反映（失敗時は戻す）
        Task {
            do {
                try await putTaskDelete(task: tasks[idx])
            } catch {
                print("delete更新失敗:", error)
                await MainActor.run {
                    tasks[idx] = before
                }
            }
        }
    }
    
    // ---- PUT用Body（TaskView内に定義しておく）----
    private struct UpdateTaskRequest: Codable {
        let id: Int
        let title: String
        let category: String
        let startDate: String
        let endDate: String
        let isDeleteFlg: Bool
        let isDone: Bool
    }

    private func isoString(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: date)
    }

    private func putTaskDone(task: TaskItem) async throws {
        guard let url = URL(string: "http://localhost:8080/api/tasks/\(task.id)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = UpdateTaskRequest(
            id: task.id,
            title: task.title,
            category: task.category,
            startDate: isoString(task.startDate),
            endDate: isoString(task.endDate),
            isDeleteFlg:task.isDeleteFlg,
            isDone: true
        )

        request.httpBody = try JSONEncoder().encode(body)

        let (_, response) = try await URLSession.shared.data(for: request)
        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }
    }
    
    private func putTaskDelete(task: TaskItem) async throws {
        guard let url = URL(string: "http://<HOST>/api/tasks/\(task.id)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = UpdateTaskRequest(
            id: task.id,
            title: task.title,
            category: task.category,
            startDate: isoString(task.startDate),
            endDate: isoString(task.endDate),
            isDeleteFlg: true,
            isDone: task.isDone
        )

        request.httpBody = try JSONEncoder().encode(body)

        let (_, response) = try await URLSession.shared.data(for: request)
        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }
    }
}
