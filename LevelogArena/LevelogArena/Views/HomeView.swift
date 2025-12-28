import SwiftUI

/// アプリのホーム画面
/// - ユーザーの現在のステータス（レベル・戦績など）を表示する
/// - 他の機能（タスク・バトル等）へのハブ的な役割
struct HomeView: View {

    /// 自分のステータス（API連携前なので今は mock データ）
    /// 将来的にはサーバーから取得した状態をここに入れる
    @State private var me: MeStatus = .mock

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    // ユーザーのステータスを表示するカード
                    HomeHeaderCard(me: me)
                        .padding(16)                       // カード内の余白
                        .background(.background)           // システム背景色
                        .clipShape(RoundedRectangle(cornerRadius: 20)) // 角丸カード
                        .overlay(
                            // 薄い枠線を付けてカード感を出す
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                        // ほんのり影を付けて浮き上がらせる
                        .shadow(color: .black.opacity(0.05), radius: 8, y: 3)
                }
                // 画面全体の余白
                .padding(16)
            }
            // ナビゲーションバーのタイトル
            .navigationTitle("Home")
        }
    }
}
