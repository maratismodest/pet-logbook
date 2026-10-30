import SwiftUI
import SwiftData

struct PetListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Pet.createdAt) private var pets: [Pet]
    @State private var isAddingPet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(pets) { pet in
                    NavigationLink(value: pet) {
                        VStack(alignment: .leading) {
                            Text(pet.name)
                                .font(.headline)
                            Text(pet.species)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: deletePets)
            }
            .navigationTitle("Питомцы")
            .navigationDestination(for: Pet.self) { pet in
                PetDetailView(pet: pet)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Добавить питомца", systemImage: "plus") {
                        isAddingPet = true
                    }
                }
            }
            .overlay {
                if pets.isEmpty {
                    ContentUnavailableView(
                        "Нет питомцев",
                        systemImage: "pawprint",
                        description: Text("Добавьте питомца, чтобы начать вести дневник.")
                    )
                }
            }
            .sheet(isPresented: $isAddingPet) {
                AddPetView()
            }
        }
    }

    private func deletePets(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(pets[index])
        }
    }
}

struct AddPetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var species = ""
    @State private var hasBirthDate = false
    @State private var birthDate = Date.now

    var body: some View {
        NavigationStack {
            Form {
                TextField("Кличка", text: $name)
                TextField("Вид и порода", text: $species)
                Toggle("Указать дату рождения", isOn: $hasBirthDate)
                if hasBirthDate {
                    DatePicker("Дата рождения", selection: $birthDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Новый питомец")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        let pet = Pet(
                            name: name.trimmingCharacters(in: .whitespaces),
                            species: species.trimmingCharacters(in: .whitespaces),
                            birthDate: hasBirthDate ? birthDate : nil
                        )
                        modelContext.insert(pet)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    PetListView()
        .modelContainer(for: [Pet.self, Entry.self], inMemory: true)
}
