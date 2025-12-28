import SwiftUI

/// 経験値バー（EXP Bar）
/// - 現在の経験値と次のレベルまでの必要経験値を可視化する
/// - RPG風の進捗バーとして HomeHeaderCard などで使う
struct ExpBar: View {

    /// 現在の経験値
    let exp: Int

    /// 次のレベルまでに必要な経験値
    let next: Int

    /// 0.0 〜 1.0 の進捗率に変換
    /// - next が 0 の場合は 0 扱い
    /// - exp が next を超えても 1.0 を上限とする
    private var progress: CGFloat {
        guard next > 0 else { return 0 }
        return min(1, max(0, CGFloat(exp) / CGFloat(next)))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // 上段：EXPラベルと数値表示
            HStack(alignment: .lastTextBaseline) {
                Text("EXP")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)

                Spacer()

                // 例: 120 / 200（次まで 80）
                Text("\(exp) / \(next)（次まで \(max(0, next - exp))）")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    // 数字がブレないよう等幅フォントに
                    .monospacedDigit()
            }

            // 下段：バー本体
            ZStack(alignment: .leading) {

                // 背景のグレーのバー
                Capsule()
                    .fill(Color(.systemGray5))
                    .frame(height: 10)

                // 進捗バー（現在のEXPに応じて伸びる）
                Capsule()
                    .fill(Color.accentColor)
                    // progress (0.0〜1.0) に応じて幅を決定
                    // 最小幅を 10 にして、EXPが0でも見えるようにする
                    .frame(width: max(10, progress * 300), height: 10)
                    // EXPが変わったときにアニメーションで伸びる
                    .animation(.easeInOut(duration: 0.2), value: progress)
            }
            // 親の幅いっぱいに広げる
            .frame(maxWidth: .infinity)
        }
    }
}
