
import Foundation

/// 画面遷移や状態管理に使うルート定義
enum Route: Hashable {
    case home
    case arena
    case battle(BattleResult)
    case ranking
}
