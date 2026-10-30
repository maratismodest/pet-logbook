import SwiftUI
import SwiftData

/// Быстрая запись свободным текстом: модель разбирает фразу,
/// владелец проверяет результат перед сохранением.
struct QuickEntryView: View {
    @Environment(\.dismiss) private var dismiss
    let pet: Pet

    @State private var text = ""
    @State private var drafts: [Entry] = []
    @State private var isParsing = false
    @State private var errorMessage: String?

    private let parser = QuickEntryParser()

    var body: some View {
        NavigationStack {
            Form {
                if let reason = QuickEntryParser.unavailableReason {
                    Section {
                        Label(reason, systemImage: "exclamationmark.triangle")
                    }
                } else {
                    Section {
                        TextField(
                            "Например: погуляли 40 минут, хромал на заднюю лапу",
                            text: $text,
                            axis: .vertical
                        )
                        .lineLimit(3...6)

                        Button {
                            Task { await parse() }
                        } label: {
                            if isParsing {
                                ProgressView()
                            } else {
                                Label("Разобрать", systemImage: "sparkles")
                            }
                        }
                        .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isParsing)
                    } footer: {
                        Text("Текст обрабатывается на устройстве и никуда не отправляется.")
                    }
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }

                if !drafts.isEmpty {
                    Section("Проверьте записи") {
                        ForEach(drafts) { entry in
                            EntryRow(entry: entry)
                        }
                        .onDelete { drafts.remove(atOffsets: $0) }
                    }
                }
            }
            .navigationTitle("Быстрая запись")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        pet.entries.append(contentsOf: drafts)
                        dismiss()
                    }
                    .disabled(drafts.isEmpty)
                }
            }
        }
    }

    private func parse() async {
        isParsing = true
        errorMessage = nil
        defer { isParsing = false }

        do {
            drafts = try await parser.parse(text, petName: pet.name)
            if drafts.isEmpty {
                errorMessage = "Не нашёл событий в тексте. Попробуйте описать подробнее."
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
