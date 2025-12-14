import SwiftUI

struct HomeView: View {
    @State private var me: MeStatus = .mock

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HomeHeaderCard(me: me)
                        .padding(16)
                        .background(.background)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 8, y: 3)
                }
                .padding(16)
            }
            .navigationTitle("Home")
        }
    }
}
