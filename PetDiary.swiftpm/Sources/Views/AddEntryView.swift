import SwiftUI
import SwiftData

/// Ручной ввод записи. Работает и без Apple Intelligence.
struct AddEntryView: View {
    @Environment(\.dismiss) private var dismiss
    let pet: Pet

    @State private var kind: EntryKind = .feeding
    @State private var date = Date.now
    @State private var note = ""
    @State private var durationMinutes: Int?
    @State private var grams: Int?

    var body: some View {
        NavigationStack {
            Form {
                Picker("Тип", selection: $kind) {
                    ForEach(EntryKind.allCases) { kind in
                        Label(kind.title, systemImage: kind.systemImage).tag(kind)
                    }
                }
                DatePicker("Когда", selection: $date)
                TextField("Заметка", text: $note, axis: .vertical)

                if kind == .walk {
                    TextField("Длительность, мин", value: $durationMinutes, format: .number)
                        .keyboardType(.numberPad)
                }
                if kind == .feeding {
                    TextField("Количество, г", value: $grams, format: .number)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Новая запись")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        let entry = Entry(
                            kind: kind,
                            date: date,
                            note: note.trimmingCharacters(in: .whitespacesAndNewlines),
                            durationMinutes: kind == .walk ? durationMinutes : nil,
                            grams: kind == .feeding ? grams : nil
                        )
                        pet.entries.append(entry)
                        dismiss()
                    }
                }
            }
        }
    }
}
