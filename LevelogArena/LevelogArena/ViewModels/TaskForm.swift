import SwiftUI

struct TaskForm: View {
    @Binding var taskName: String
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var selectedItem: String
    @Binding var inputMemo: String

    let status = ["筋肉", "器用さ", "知力", "敏捷性", "体力", "魅力", "運"]

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
