import SwiftUI

struct TaskSession: Decodable {
    let id: Int
    let taskId: Int
    let userId: String
    let startedAt: Date
    let endedAt: Date?
    let durationSec: Int
}
