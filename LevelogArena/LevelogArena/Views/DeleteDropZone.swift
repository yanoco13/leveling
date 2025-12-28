import SwiftUI
import UniformTypeIdentifiers

/// タスクをドラッグしてドロップすると「削除」扱いにするゾーン
/// - TaskView などで、タスクのID（String）を受け取り
/// - Int に変換して onDropTaskId に渡す
struct DeleteDropZone: View {

    /// ドロップされたタスクIDを親Viewに通知するコールバック
    let onDropTaskId: (Int) -> Void

    /// ドロップ対象になっているかどうか（ハイライト用）
    @State private var isTargeted = false

    var body: some View {
        Image(systemName: "trash.fill")
            .font(.system(size: 40))
            .padding(12)

            // ドロップ中は赤くして「ここに落とせる」ことを示す
            .foregroundColor(isTargeted ? .red : .primary)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            // ドロップ対象時の強調枠線
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isTargeted ? .red : .clear, lineWidth: 3)
            )

            // このViewをドロップ先として登録
            // UTType.text = タスクIDを文字列で受け取る
            .onDrop(of: [UTType.text], isTargeted: $isTargeted) { providers in

                // 最初の provider だけ使う
                guard let provider = providers.first else { return false }

                // 実際のデータ（String or Data）を非同期で読み込む
                provider.loadItem(
                    forTypeIdentifier: UTType.text.identifier,
                    options: nil
                ) { item, _ in

                    // item を String に変換
                    let text: String?
                    if let s = item as? String {
                        text = s
                    } else if let d = item as? Data {
                        text = String(data: d, encoding: .utf8)
                    } else {
                        text = nil
                    }

                    // 文字列 → Int（タスクID）に変換
                    guard let text,
                          let id = Int(text.trimmingCharacters(in: .whitespacesAndNewlines))
                    else { return }

                    // UI更新・親コールバックは必ずメインスレッドで
                    DispatchQueue.main.async {
                        onDropTaskId(id)
                    }
                }

                // このドロップを受理したことをSwiftUIに伝える
                return true
            }
    }
}
