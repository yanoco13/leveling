import SwiftUI
import UniformTypeIdentifiers

struct DeleteDropZone: View {
    let onDropTaskId: (Int) -> Void
    @State private var isTargeted = false

    var body: some View {
        Image(systemName: "trash.fill")
            .font(.system(size: 40))
            .padding(12)
            .foregroundColor(isTargeted ? .red : .primary)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isTargeted ? .red : .clear, lineWidth: 3)
            )
            .onDrop(of: [UTType.text], isTargeted: $isTargeted) { providers in
                guard let provider = providers.first else { return false }

                provider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { item, _ in
                    let text: String?
                    if let s = item as? String {
                        text = s
                    } else if let d = item as? Data {
                        text = String(data: d, encoding: .utf8)
                    } else {
                        text = nil
                    }

                    guard let text,
                          let id = Int(text.trimmingCharacters(in: .whitespacesAndNewlines))
                    else { return }

                    DispatchQueue.main.async {
                        onDropTaskId(id)
                    }
                }
                return true
            }
    }
}
