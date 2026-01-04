import SwiftUI

struct TaskForm: View {
    @Binding var taskName: String
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var selectedItem: String
    @Binding var inputMemo: String

    let status = ["筋トレ", "仕事", "勉強", "趣味", "その他"]

    var body: some View {
        VStack {
            TextField("タスク名", text: $taskName)
                .textFieldStyle(.roundedBorder)
                .padding()

            DatePicker("開始", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                .padding()

            DatePicker("終了", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                .padding()

            Picker("カテゴリー", selection: $selectedItem) {
                ForEach(status, id: \.self) { s in
                    Text(s)
                }
            }
            .pickerStyle(.menu)
            .padding()

            TextField("メモ", text: $inputMemo)
                .textFieldStyle(.roundedBorder)
                .padding()
        }
    }
}
