import SwiftUI

/// Home画面の上部に表示される「ユーザーステータスカード」
/// - 名前 / レベル
/// - 経験値バー
/// - 各種ステータス（STR, AGI など）
/// - Tasks / Battle への導線
struct HomeHeaderCard: View {

    /// 表示するユーザーの状態（名前・レベル・能力値など）
    let me: MeStatus

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            // 名前・レベル・アクションボタン
            header

            // 経験値バー（現在のexp と 次のレベルまでの必要exp）
            ExpBar(exp: me.exp, next: me.nextExp)

            // ステータス一覧（STR, AGI, INTなど）
            stats
        }
    }

    // MARK: - Header（名前・レベル・ボタン）

    /// ユーザー名とレベル、右側にアクションボタンを配置したヘッダー
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {

                // 挨拶（サブテキスト）
                Text("Welcome back")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                // ユーザー名とレベル表示
                Text("\(me.name) / Lv.\(me.level)")
                    .font(.title2)
                    .fontWeight(.semibold)
            }

            Spacer()

            // Tasks / Battle へのショートカット
            actions
        }
    }

    // MARK: - Actions（画面遷移ボタン）

    /// Tasks画面・Battle画面へのナビゲーションボタン
    private var actions: some View {
        HStack(spacing: 10) {

            // タスク管理画面へ
            NavigationLink("Tasks") {
                Text("Tasks")
            }
            .buttonStyle(.borderedProminent)

            // バトル画面へ
            NavigationLink("Battle") {
                Text("Battle")
            }
            .buttonStyle(.bordered)
        }
    }

    // MARK: - Stats（能力値）

    /// キャラクターの能力値をチップ形式で表示
    private var stats: some View {
        FlowChips {
            StatChip(label: "STR",  value: me.stats.str)     // 攻撃力
            StatChip(label: "AGI",  value: me.stats.agi)     // 素早さ
            StatChip(label: "INT",  value: me.stats.intell)  // 知力
            StatChip(label: "VIT",  value: me.stats.vit)     // 体力
            StatChip(label: "LUCK", value: me.stats.luck)    // 運
        }
    }
}
