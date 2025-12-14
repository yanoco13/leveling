import SwiftUI

struct ExpBar: View {
    let exp: Int
    let next: Int

    private var progress: CGFloat {
        guard next > 0 else { return 0 }
        return min(1, max(0, CGFloat(exp) / CGFloat(next)))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .lastTextBaseline) {
                Text("EXP")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)

                Spacer()

                Text("\(exp) / \(next)（次まで \(max(0, next - exp))）")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(.systemGray5))
                    .frame(height: 10)

                Capsule()
                    .fill(Color.accentColor)
                    .frame(width: max(10, progress * 300), height: 10) // 最小幅10で見えやすく
                    .animation(.easeInOut(duration: 0.2), value: progress)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
