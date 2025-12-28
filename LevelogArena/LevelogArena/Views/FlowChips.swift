import SwiftUI

/// チップ（StatChip など）を横に並べて、
/// 画面幅に収まらなくなったら自動で改行してくれるコンテナ
/// CSS の `flex-wrap` や `flow layout` に近い動き
@available(iOS 16.0, *)
struct FlowChips<Content: View>: View {

    /// 中に並べるビュー（例：StatChip）
    @ViewBuilder var content: Content

    var body: some View {
        // FlowLayout を使って、中身を自動折り返し配置
        FlowLayout(spacing: 8) {
            content
        }
    }
}

@available(iOS 16.0, *)
struct FlowLayout: Layout {

    /// 各アイテムの間隔
    var spacing: CGFloat = 8

    // MARK: - レイアウトの「サイズ計算」

    /// FlowLayout 全体がどれくらいのサイズになるかを計算する
    /// SwiftUI が View の高さを決めるために呼ばれる
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {

        // 親から提案された最大幅（nil の場合は 0 として扱う）
        let maxWidth = proposal.width ?? 0

        var x: CGFloat = 0          // 現在の行のX位置
        var y: CGFloat = 0          // 現在のY位置（行の開始）
        var rowHeight: CGFloat = 0  // 現在の行の高さ

        // 各サブビュー（チップ）を順番に並べてシミュレーション
        for sub in subviews {
            let size = sub.sizeThatFits(.unspecified)

            // 今の行に置くと幅オーバーするなら改行
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing   // 次の行へ
                rowHeight = 0
            }

            // Xを進める
            x += size.width + spacing

            // 行の最大高さを更新
            rowHeight = max(rowHeight, size.height)
        }

        // 全体のサイズ（高さは最後の行まで含める）
        return CGSize(width: maxWidth, height: y + rowHeight)
    }

    // MARK: - 実際の配置処理

    /// 計算した結果をもとに、各サブビューを実際に画面上へ配置する
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {

        var x = bounds.minX        // 現在の配置X
        var y = bounds.minY        // 現在の配置Y
        var rowHeight: CGFloat = 0

        for sub in subviews {
            let size = sub.sizeThatFits(.unspecified)

            // 今の行に収まらなければ改行
            if x + size.width > bounds.maxX, x > bounds.minX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }

            // サブビューを現在の (x, y) に配置
            sub.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))

            // 次のX位置へ
            x += size.width + spacing

            // 行の高さを更新
            rowHeight = max(rowHeight, size.height)
        }
    }
}
