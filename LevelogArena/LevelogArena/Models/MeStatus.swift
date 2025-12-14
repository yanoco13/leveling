import Foundation

struct MeStatus: Codable {
    let name: String
    let level: Int
    let exp: Int
    let nextExp: Int
    let stats: Stats

    struct Stats: Codable {
        let str: Int
        let agi: Int
        let intell: Int
        let vit: Int
        let luck: Int
    }
}

extension MeStatus {
    static let mock = MeStatus(
        name: "You",
        level: 3,
        exp: 42,
        nextExp: 80,
        stats: .init(str: 12, agi: 9, intell: 15, vit: 10, luck: 7)
    )
}
