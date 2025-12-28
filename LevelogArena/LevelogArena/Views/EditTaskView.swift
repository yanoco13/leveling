import SwiftUI

/// タスク編集画面（TaskAPI経由で更新）
struct EditTaskView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var task: TaskItem
    let taskAPI: TaskAPI

    @State private var taskName = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var selectedItem = "力"
    @State private var inputMemo = ""

    var body: some View {
        VStack {
            TaskForm(
                taskName: $taskName,
                startDate: $startDate,
                endDate: $endDate,
                selectedItem: $selectedItem,
                inputMemo: $inputMemo
            )

            Button("更新") { updateTask() }
                .padding()

            Button("閉じる") { dismiss() }
        }
        .navigationTitle("タスク編集")
        .onAppear {
            taskName = task.title
            startDate = task.startDate
            endDate = task.endDate
            selectedItem = task.category
        }
    }

    private func updateTask() {
        let id = task.id

        Task {
            do {
                let updated = try await taskAPI.updateFromEditor(
                    taskId: id,
                    title: taskName,
                    category: selectedItem,
                    startDate: startDate,
                    endDate: endDate,
                    isDeleteFlg: task.isDeleteFlg,
                    isDone: task.isDone
                )

                await MainActor.run {
                    // サーバの返却を正として反映（Bindingなので親の一覧にも反映）
                    task = updated
                    dismiss()
                }
            } catch {
                print("updateTask failed:", error)
            }
        }
    }
}
