import SwiftUI

struct TaskView: View {
    @EnvironmentObject private var store: LogStore
    @EnvironmentObject private var state: AppState

    @State private var tasks: [TaskItem] = []
    @State private var showAddModal = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                addButton
                taskList
                actionDropZones
            }
            .navigationTitle("Tasks")
            .sheet(isPresented: $showAddModal, onDismiss: {
                loadTasks()
            }) {
                AddTaskView { created in
                    tasks.insert(created, at: 0)
                }
            }
            .onAppear { loadTasks() }
        }
    }
}

private extension TaskView {
    var addButton: some View {
        Button(TaskConstants.MESSAGE_ADD_TASK) { showAddModal = true }
            .padding()
    }

    var taskList: some View {
        List {
            ForEach($tasks.filter { !$0.wrappedValue.isDone && !$0.wrappedValue.isDeleteFlg }) { $task in
                NavigationLink(destination: EditTaskView(task: $task, taskAPI: state.taskAPI)) {
                    Text(task.title)
                        .draggable(String(task.id))
                }
            }
        }
    }

    var actionDropZones: some View {
        HStack(spacing: 24) {
            VStack {
                DoneDropZone { droppedId in
                    markDoneAndSync(id: droppedId)
                }
                Text("Done").font(.caption2)
            }

            VStack {
                DeleteDropZone { droppedId in
                    markDeleteAndSync(id: droppedId)
                }
                Text("削除").font(.caption2)
            }
        }
    }
}

// MARK: - Networking（TaskAPI経由）
private extension TaskView {

    func loadTasks() {
        Task {
            do {
                let fetched = try await state.taskAPI.fetchTasks()
                self.tasks = fetched
            } catch {
                print("loadTasks error:", error)
                state.toast = Toast(message: "タスク取得に失敗しました")
            }
        }
    }
}

// MARK: - Optimistic Update + Rollback
private extension TaskView {

    func markDoneAndSync(id: Int) {
        guard let idx = tasks.firstIndex(where: { $0.id == id }) else { return }
        let before = tasks[idx]

        // ① UI即時反映
        tasks[idx].isDone = true

        // ② ログ（カレンダー用）
        store.addEntry(
            title: before.title,
            note: "カテゴリ: \(before.category)",
            date: Date(),
            category: .doneTask
        )

        // ③ サーバ反映（失敗時ロールバック）
        Task {
            do {
                try await state.taskAPI.completeTask(id: id)
            } catch {
                print("done更新失敗:", error)
                await MainActor.run { tasks[idx] = before }
                state.toast = Toast(message: "完了更新に失敗しました")
            }
        }
    }

    func markDeleteAndSync(id: Int) {
        guard let idx = tasks.firstIndex(where: { $0.id == id }) else { return }
        let before = tasks[idx]

        // ① UI即時反映
        tasks[idx].isDeleteFlg = true

        // ② サーバ反映（失敗時ロールバック）
        Task {
            do {
                _ = try await state.taskAPI.softDelete(task: tasks[idx])
            } catch {
                print("delete更新失敗:", error)
                await MainActor.run { tasks[idx] = before }
                state.toast = Toast(message: "削除更新に失敗しました")
            }
        }
    }
}
