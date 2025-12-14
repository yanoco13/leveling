import SwiftUI

struct StatChip: View {
    let label: String
    let value: Int

    var body: some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            Text("\(value)")
                .font(.subheadline)
                .fontWeight(.bold)
                .monospacedDigit()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .clipShape(Capsule())
        .overlay(
            Capsule().stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}
