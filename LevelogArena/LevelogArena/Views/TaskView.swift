import SwiftUI

struct TaskView: View {
    @State private var tasks: [TaskItem] = []
    @State private var showModal = false
    @State private var editingTask: TaskItem? = nil

    var body: some View {
        NavigationStack {
            VStack {
                Button(TaskConstants.MESSAGE_ADD_TASK) {
                    editingTask = nil       // ← 新規作成
                    showModal = true
                }
                .padding()

                List(tasks) { task in
                    NavigationLink(destination: TaskDetailView(task: task)) {
                        Text(task.title)
                    }
                    .swipeActions {
                        Button("編集") {
                            editingTask = task
                            showModal = true
                        }
                        .tint(.blue)
                    }
                }
            }
            .sheet(isPresented: $showModal) {
                TaskDetailView(task: editingTask)
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

        URLSession.shared.dataTask(with: request) { data, response, error in
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
        }.resume()
    }
}
