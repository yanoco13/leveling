import Foundation
import SwiftUI
import Combine
/// タスク一覧の状態と操作を管理するViewModel
/// - View からURLSessionを消すための層
/// - TaskAPI（async/await）に集約して呼び出す
@MainActor
final class TaskViewModel: ObservableObject {

    // 画面に表示するタスク一覧
    @Published private(set) var tasks: [TaskItem] = []

    // 通信中やエラー表示をしたければ追加で持てる
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let taskAPI: TaskAPI

    /// 依存注入：テストや環境切替が楽になる
    init(taskAPI: TaskAPI) {
        self.taskAPI = taskAPI
    }

    // MARK: - Read

    /// タスク取得（GET /api/tasks）
    func loadTasks() async {
        isLoading = true
        defer { isLoading = false }

        do {
            tasks = try await taskAPI.fetchTasks()
        } catch {
            print("Fetch error:", error)
        }
    }

    // MARK: - Create

    /// タスク作成（POST /api/tasks）
    func createTask(title: String, category: String, startDate: Date, endDate: Date) async {
        do {
            let body = TaskAPI.CreateTaskRequest(
                title: title,
                category: category,
                startDate: TaskAPI.isoString(startDate),
                endDate: TaskAPI.isoString(endDate),
                isDeleteFlg: false,
                isDone: false
            )
            let created = try await taskAPI.createTask(body)
            // 先頭に追加したいなら insert(created, at: 0)
            tasks.insert(created, at: 0)
        } catch {
            errorMessage = "タスク作成に失敗しました: \(error)"
            print("Create error:", error)
        }
    }

    // MARK: - Update

    /// タスク更新（PUT /api/tasks/{id}）
    func updateTask(id: Int, title: String, category: String, startDate: Date, endDate: Date, isDone: Bool, isDeleteFlg: Bool) async {
        do {
            let body = TaskAPI.UpdateTaskRequest(
                id: id,
                title: title,
                category: category,
                startDate: TaskAPI.isoString(startDate),
                endDate: TaskAPI.isoString(endDate),
                isDeleteFlg: isDeleteFlg,
                isDone: isDone
            )

            let updated = try await taskAPI.updateTask(id: id, body: body)

            if let index = tasks.firstIndex(where: { $0.id == id }) {
                tasks[index] = updated
            }
        } catch {
            errorMessage = "タスク更新に失敗しました: \(error)"
            print("Update error:", error)
        }
    }

    // MARK: - Complete / Delete

    /// 完了（POST /api/tasks/{id}/complete）
    func completeTask(id: Int) async {
        do {
            try await taskAPI.completeTask(id: id)
            if let index = tasks.firstIndex(where: { $0.id == id }) {
                tasks[index].isDone = true
            }
        } catch {
            errorMessage = "完了更新に失敗しました: \(error)"
            print("Complete error:", error)
        }
    }

    /// 削除（PUT /api/tasks/{id} isDeleteFlg=true）
    func deleteTask(id: Int) async {
        do {
            guard let task = tasks.first(where: { $0.id == id }) else { return }
            let updated = try await taskAPI.softDelete(task: task)
            if let index = tasks.firstIndex(where: { $0.id == id }) {
                tasks[index] = updated
            }
        } catch {
            errorMessage = "削除更新に失敗しました: \(error)"
            print("Delete error:", error)
        }
    }
}
