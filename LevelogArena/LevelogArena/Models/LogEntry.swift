import Foundation

struct LogEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    var title: String
    var note: String?
    var durationMinutes: Int?
    var category: Category?

    enum Category: String, Codable, CaseIterable, Identifiable {
        case work
        case study
        case health
        case hobby
        case other

        var id: String { rawValue }

        var label: String {
            switch self {
            case .work: return "仕事"
            case .study: return "勉強"
            case .health: return "健康"
            case .hobby: return "趣味"
            case .other: return "その他"
            }
        }

        var emoji: String {
            switch self {
            case .work: return "💼"
            case .study: return "📚"
            case .health: return "💪"
            case .hobby: return "🎨"
            case .other: return "✨"
            }
        }
    }

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        title: String,
        note: String? = nil,
        durationMinutes: Int? = nil,
        category: Category? = nil
    ) {
        self.id = id
        self.date = date
        self.title = title
        self.note = note
        self.durationMinutes = durationMinutes
        self.category = category
    }
}
