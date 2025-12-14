import SwiftUI

struct HomeHeaderCard: View {
    let me: MeStatus

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            ExpBar(exp: me.exp, next: me.nextExp)
            stats
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("\(me.name) / Lv.\(me.level)")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            Spacer()
            actions
        }
    }

    private var actions: some View {
        HStack(spacing: 10) {
            NavigationLink("Tasks") { Text("Tasks") }
                .buttonStyle(.borderedProminent)
            NavigationLink("Battle") { Text("Battle") }
                .buttonStyle(.bordered)
        }
    }

    private var stats: some View {
        FlowChips {
            StatChip(label: "STR", value: me.stats.str)
            StatChip(label: "AGI", value: me.stats.agi)
            StatChip(label: "INT", value: me.stats.intell)
            StatChip(label: "VIT", value: me.stats.vit)
            StatChip(label: "LUCK", value: me.stats.luck)
        }
    }
}
