import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var state: AppState   // ← taskAPIを使う

    @State private var taskName = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var selectedItem = "筋トレ"
    @State private var inputMemo = ""

    let onCreated: (TaskItem) -> Void

    var body: some View {
        NavigationStack {
            VStack {
                TaskForm(
                    taskName: $taskName,
                    startDate: $startDate,
                    endDate: $endDate,
                    selectedItem: $selectedItem,
                    inputMemo: $inputMemo
                )

                Button("追加") {
                    Task { await createTask() }
                }
                .padding()
                .disabled(taskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                Button("閉じる") { dismiss() }
            }
            .navigationTitle("新規タスク")
        }
    }

    /// ✅ TaskAPI 経由で作成（Authorization付きになる）
    @MainActor
    private func createTask() async {
        do {
            let body = TaskAPI.CreateTaskRequest(
                title: taskName,
                category: selectedItem,
                startDate: TaskAPI.isoString(startDate),
                endDate: TaskAPI.isoString(endDate),
                isDeleteFlg: false,
                isDone: false
            )

            let created = try await state.taskAPI.createTask(body)

            // 親へ「確定ID」のタスクを渡す（これ1回だけ）
            onCreated(created)

            dismiss()
        } catch {
            print("Create task failed:", error)
            state.toast = Toast(message: "タスク追加に失敗しました")
        }
    }
}
