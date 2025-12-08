import Foundation
import SwiftUI
import Combine

class TaskViewModel: ObservableObject {

    @Published var tasks: [TaskItem] = []

    // 読み込み
    func loadTasks() {
        TaskAPI.fetchTasks { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self.tasks = items
                case .failure(let error):
                    print("Fetch error:", error)
                }
            }
        }
    }

    // 新規
    func createTask(title: String, category: String,
                    startDate: Date, endDate: Date) {

        let body = CreateTaskRequest(
            title: title,
            category: category,
            startDate: isoString(startDate),
            endDate: isoString(endDate),
            isDone: false
        )

        TaskAPI.createTask(body) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let task):
                    self.tasks.append(task)
                case .failure(let error):
                    print("Create error:", error)
                }
            }
        }
    }

    // 更新
    func updateTask(id: Int, title: String, category: String,
                    startDate: Date, endDate: Date, isDone: Bool) {

        let body = UpdateTaskRequest(
            id: id,
            title: title,
            category: category,
            startDate: isoString(startDate),
            endDate: isoString(endDate),
            isDone: isDone
        )

        TaskAPI.updateTask(id: id, body: body) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updated):
                    if let index = self.tasks.firstIndex(where: { $0.id == id }) {
                        self.tasks[index] = updated
                    }
                case .failure(let error):
                    print("Update error:", error)
                }
            }
        }
    }
}

// ISO文字列変換
func isoString(_ date: Date) -> String {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter.string(from: date)
}
