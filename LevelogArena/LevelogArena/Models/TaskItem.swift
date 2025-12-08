import Foundation

struct TaskItem: Identifiable, Codable {
    var id: Int
    var title: String
    var isDone: Bool? = false
    var startDate: Date
    var endDate: Date
    var category: String = "力"
}
