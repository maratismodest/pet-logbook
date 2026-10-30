import SwiftUI
import SwiftData

/// Лента записей одного питомца с фильтром по типу.
struct PetDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let pet: Pet

    @State private var filter: EntryKind?
    @State private var isAddingEntry = false
    @State private var isQuickEntryShown = false

    private var visibleEntries: [Entry] {
        pet.entries
            .filter { filter == nil || $0.kind == filter }
            .sorted { $0.date > $1.date }
    }

    var body: some View {
        List {
            ForEach(visibleEntries) { entry in
                EntryRow(entry: entry)
            }
            .onDelete(perform: deleteEntries)
        }
        .navigationTitle(pet.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu("Add", systemImage: "plus") {
                    Button("Quick Entry", systemImage: "sparkles") {
                        isQuickEntryShown = true
                    }
                    Button("Manual Entry", systemImage: "square.and.pencil") {
                        isAddingEntry = true
                    }
                }
            }
            ToolbarItem(placement: .secondaryAction) {
                NavigationLink {
                    VetReportView(pet: pet)
                } label: {
                    Label("Vet Summary", systemImage: "doc.text.magnifyingglass")
                }
            }
            ToolbarItem(placement: .secondaryAction) {
                Picker("Filter", selection: $filter) {
                    Text("All").tag(EntryKind?.none)
                    ForEach(EntryKind.allCases) { kind in
                        Label(kind.title, systemImage: kind.systemImage)
                            .tag(EntryKind?.some(kind))
                    }
                }
            }
        }
        .overlay {
            if visibleEntries.isEmpty {
                ContentUnavailableView(
                    "No Entries",
                    systemImage: "list.bullet.clipboard",
                    description: Text("Add a feeding, walk, or symptom.")
                )
            }
        }
        .sheet(isPresented: $isAddingEntry) {
            AddEntryView(pet: pet)
        }
        .sheet(isPresented: $isQuickEntryShown) {
            QuickEntryView(pet: pet)
        }
    }

    private func deleteEntries(at offsets: IndexSet) {
        let entries = visibleEntries
        for index in offsets {
            modelContext.delete(entries[index])
        }
    }
}

struct EntryRow: View {
    let entry: Entry

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: entry.kind.systemImage)
                .foregroundStyle(.tint)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(entry.kind.title)
                        .font(.headline)
                    Spacer()
                    Text(entry.date, format: .dateTime.day().month().hour().minute())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                if !entry.note.isEmpty {
                    Text(entry.note)
                }
                if let detail = entry.detailText {
                    Text(detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .accessibilityElement(children: .combine)
    }
}
