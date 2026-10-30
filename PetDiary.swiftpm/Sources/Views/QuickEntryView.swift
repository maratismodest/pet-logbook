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
                if let reason = ModelAvailability.unavailableReason {
                    Section {
                        Label(reason, systemImage: "exclamationmark.triangle")
                    }
                } else {
                    Section {
                        TextField(
                            "For example: 40-minute walk, limping on a back leg",
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
                                Label("Create Entries", systemImage: "sparkles")
                            }
                        }
                        .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isParsing)
                    } footer: {
                        Text("Your text is processed on this device and never leaves it.")
                    }
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }

                if !drafts.isEmpty {
                    Section("Review Entries") {
                        ForEach(drafts) { entry in
                            EntryRow(entry: entry)
                        }
                        .onDelete { drafts.remove(atOffsets: $0) }
                    }
                }
            }
            .navigationTitle("Quick Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
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
                errorMessage = "No events found in the text. Try adding more detail."
            }
        } catch {
            errorMessage = ModelAvailability.message(for: error)
        }
    }
}
