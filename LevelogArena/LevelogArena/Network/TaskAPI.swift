import Foundation
import SwiftUI

struct CreateTaskRequest: Codable {
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

class TaskAPI {
    static let baseURL = "http://localhost:8080/api/tasks"

    static func fetchTasks(completion: @escaping (Result<[TaskItem], Error>) -> Void) {
        let url = URL(string: baseURL)!
        TaskAPIClient.shared.sendRequest(url: url, method: "GET", completion: completion)
    }

    static func createTask(_ body: CreateTaskRequest,
                           completion: @escaping (Result<TaskItem, Error>) -> Void) {

        let url = URL(string: baseURL)!
        TaskAPIClient.shared.sendRequest(url: url, method: "POST", body: body, completion: completion)
    }

    static func updateTask(id: Int, body: UpdateTaskRequest,
                           completion: @escaping (Result<TaskItem, Error>) -> Void) {

        let url = URL(string: "\(baseURL)/\(id)")!
        TaskAPIClient.shared.sendRequest(url: url, method: "PUT", body: body, completion: completion)
    }
}
