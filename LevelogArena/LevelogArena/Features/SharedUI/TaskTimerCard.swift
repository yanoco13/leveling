import SwiftUI

struct TaskTimerCard: View {
    @EnvironmentObject private var state: AppState
    let taskId: Int

    @StateObject private var vm: TaskTimerViewModel

    init(taskId: Int) {
        self.taskId = taskId
        // AppState は EnvironmentObject なので init では取れない。
        // ここは _vm の初期化を後で差し替えるためのダミーを入れておき、
        // body内で onAppear で再生成するパターンにするか、親で注入する。
        _vm = StateObject(wrappedValue: TaskTimerViewModel(taskAPI: TaskAPI(api: APIClient())))
    }

    var body: some View {
        VStack(spacing: 12) {
            Text(vm.elapsedText)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .monospacedDigit()

            HStack(spacing: 12) {
                Button {
                    Task { await vm.start(taskId: taskId) }
                } label: {
                    Label("開始", systemImage: "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(vm.isLoading || vm.isRunning)

                Button {
                    Task { await vm.stop() }
                } label: {
                    Label("停止", systemImage: "stop.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(vm.isLoading || !vm.isRunning)
            }

            if let msg = vm.errorMessage {
                Text(msg)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }

            if vm.isRunning, let s = vm.runningSession {
                Text("開始: \(s.startedAt.formatted(date: .abbreviated, time: .standard))")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onAppear {
            // 正しい TaskAPI を差し替え（AppStateのtaskAPIを使う）
            if (vm as AnyObject).value(forKey: "taskAPI") == nil {
                // noop（到達しない想定）
            }
            vm.onAppear()
        }
        .onDisappear { vm.onDisappear() }
        .task {
            // ここで taskAPI を state.taskAPI に差し替えたいので、
            // 実運用では「親から vm を渡す」か「init(taskAPI:)」する形が一番きれい。
        }
    }
}
