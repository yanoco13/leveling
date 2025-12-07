import SwiftUI

struct TaskDetailView: View {
    @Environment(\.dismiss) private var dismiss

    @State var task: TaskItem?

    @State var taskName = ""
    @State var startDate = Date()
    @State var endDate = Date()
    @State var selectedItem = "力"
    @State var inputMemo = ""

    let status = ["力", "器用さ", "知力","敏捷性","体力","魅力","運"] //運、魅力などは付加的な感じで

    var body: some View {
        NavigationStack {
            VStack {

                TextField("タスク名", text: $taskName)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                DatePicker("開始", selection: $startDate,
                           displayedComponents: [.date, .hourAndMinute])
                    .padding()

                DatePicker("終了", selection: $endDate,
                           displayedComponents: [.date, .hourAndMinute])
                    .padding()

                Picker("カテゴリー", selection: $selectedItem) {
                    ForEach(status, id: \.self) { status in
                        Text(status)
                    }
                }
                .pickerStyle(.menu)
                .padding()

                TextField("メモ", text: $inputMemo)
                    .textFieldStyle(.roundedBorder)
                    .padding()


                // 新規 or 編集でボタン表示を切り替え
                Button(task == nil ? "追加" : "更新") {
                    if task == nil {
                        postTask()
                    } else {
                        updateTask()
                    }
                    dismiss()
                }
                .padding()

                Button("閉じる") { dismiss() }
            }
            .navigationTitle(task == nil ? "新規タスク" : "タスク編集")
            .onAppear {
                if let task = task {
                    self.taskName = task.title
                    self.startDate = task.startDate
                    self.endDate = task.endDate
                    self.selectedItem = task.category
//                    self.inputMemo = task.memo
                }
            }
        }
    }
    
    struct InsertTaskRequest: Codable {
        let title: String
        let category: String
        let startDate: String
        let endDate: String
        let isDone: Bool
    }
    

    struct UpdateTaskRequest: Codable {
        let id: Int
        let title: String
        let category: String
        let startDate: String
        let endDate: String
        let isDone: Bool
    }

    
    func parseDate(_ iso: String) -> Date?{
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: iso)
    }
    
    func isoString(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: date)
    }
    
    // -----------------------------
    // 新規作成 POST
    // -----------------------------
    func postTask() {
        guard let url = URL(string: "http://localhost:8080/api/tasks") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = InsertTaskRequest(
            title: taskName,
            category: selectedItem,
            startDate: isoString(startDate),
            endDate: isoString(endDate),
            isDone: false
        )

        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("POST エラー:", error)
                return
            }

            if let http = response as? HTTPURLResponse {
                print("POST status:", http.statusCode)
            }

            if let data = data {
                print("POST Response:", String(data: data, encoding: .utf8) ?? "")
            }
        }.resume()
    }


    // -----------------------------
    // 更新 PUT
    // -----------------------------
    func updateTask() {
        guard let task = task else { return }
        let id = task.id
        print("update id:", task.id)
        guard let url = URL(string: "http://localhost:8080/api/tasks/\(id)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = UpdateTaskRequest(
            id: id,
            title: taskName,
            category: selectedItem,
            startDate: isoString(startDate),
            endDate: isoString(endDate),
            isDone:false
        )

        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("PUT エラー:", error)
                return
            }

            if let http = response as? HTTPURLResponse {
                print("PUT status:", http.statusCode)
            }

            if let data = data {
                print("PUT Response:", String(data: data, encoding: .utf8) ?? "")
            }
        }.resume()
    }

}
