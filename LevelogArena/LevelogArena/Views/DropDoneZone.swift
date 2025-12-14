import SwiftUI
import UniformTypeIdentifiers

// -----------------------------
// Done 用ドロップゾーン
// -----------------------------
// ・タスク行をドラッグしてドロップすると
//   そのタスクを「完了（done）」にするためのView
struct DoneDropZone: View {

    // ドロップされたタスクIDを親へ通知するクロージャ
    let onDropTaskId: (Int) -> Void

    // ドロップ対象としてホバーされているかどうか
    // true の間は枠線を表示する
    @State private var isTargeted = false

    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            // アイコンサイズ
            .font(.system(size: 44))
            // タップ・ドロップしやすい余白
            .padding(12)
            // 背景（半透明）
            .background(.thinMaterial)
            // 角丸
            .clipShape(RoundedRectangle(cornerRadius: 16))
            // 👇 ドロップ中はアイコンも緑にする
            .foregroundColor(isTargeted ? .green : .primary)

            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            // 👇 ドロップ中は枠線を緑にする
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isTargeted ? .green : .clear, lineWidth: 3)
            )

            // -----------------------------
            // ドロップ処理
            // -----------------------------
            // ・受け取る型はテキスト（task.id を String として渡している）
            // ・isTargeted でドロップ中の状態を検知
            .onDrop(of: [UTType.text], isTargeted: $isTargeted) { providers in

                // ドロップされたアイテムが存在しない場合は終了
                guard let provider = providers.first else {
                    return false
                }

                // ドロップされたデータを読み込む
                provider.loadItem(
                    forTypeIdentifier: UTType.text.identifier,
                    options: nil
                ) { item, _ in

                    // -----------------------------
                    // item の型は環境によって異なる
                    // ・String の場合
                    // ・Data の場合
                    // があるため両方に対応する
                    // -----------------------------
                    let text: String?
                    if let s = item as? String {
                        text = s
                    } else if let d = item as? Data {
                        text = String(data: d, encoding: .utf8)
                    } else {
                        text = nil
                    }

                    // テキストを Int（task.id）に変換
                    guard
                        let text,
                        let id = Int(
                            text.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                    else {
                        return
                    }

                    // -----------------------------
                    // UI更新は必ずメインスレッドで
                    // -----------------------------
                    DispatchQueue.main.async {
                        // 親Viewへ task.id を通知
                        // → 親側で isDone = true などを行う
                        onDropTaskId(id)
                    }
                }

                // true を返すとドロップ成功扱い
                return true
            }
    }
}
