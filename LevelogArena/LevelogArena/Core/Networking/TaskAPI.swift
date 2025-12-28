import Foundation

extension TaskAPI {
    /// Date → ISO8601 文字列変換
    /// サーバーが期待している形式に変換するためのユーティリティ
    static func isoString(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: date)
    }
}

final class TaskAPI {
    private let api: APIClient

    init(api: APIClient) {
        self.api = api
    }

    // ---- DTO ----

    struct CreateTaskRequest: Encodable {
        let title: String
        let category: String
        let startDate: String
        let endDate: String
        let isDeleteFlg: Bool
        let isDone: Bool
    }

    struct UpdateTaskRequest: Encodable {
        let id: Int
        let title: String
        let category: String
        let startDate: String
        let endDate: String
        let isDeleteFlg: Bool
        let isDone: Bool
    }

    // ---- API ----

    func fetchTasks() async throws -> [TaskItem] {
        try await api.request("/api/tasks")
    }

    func createTask(_ body: CreateTaskRequest) async throws -> TaskItem {
        try await api.request("/api/tasks", method: "POST", body: body)
    }

    func updateTask(id: Int, body: UpdateTaskRequest) async throws -> TaskItem {
        try await api.request("/api/tasks/\(id)", method: "PUT", body: body)
    }

    func completeTask(id: Int) async throws {
        _ = try await api.requestVoid("/api/tasks/\(id)/complete", method: "POST")
    }

    func softDelete(task: TaskItem) async throws -> TaskItem {
        let body = UpdateTaskRequest(
            id: task.id,
            title: task.title,
            category: task.category,
            startDate: iso(task.startDate),
            endDate: iso(task.endDate),
            isDeleteFlg: true,
            isDone: task.isDone
        )
        return try await updateTask(id: task.id, body: body)
    }

    func updateFromEditor(
        taskId: Int,
        title: String,
        category: String,
        startDate: Date,
        endDate: Date,
        isDeleteFlg: Bool,
        isDone: Bool
    ) async throws -> TaskItem {
        let body = UpdateTaskRequest(
            id: taskId,
            title: title,
            category: category,
            startDate: iso(startDate),
            endDate: iso(endDate),
            isDeleteFlg: isDeleteFlg,
            isDone: isDone
        )
        return try await updateTask(id: taskId, body: body)
    }

    // ---- Helpers ----
    private func iso(_ date: Date) -> String {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f.string(from: date)
    }
}
