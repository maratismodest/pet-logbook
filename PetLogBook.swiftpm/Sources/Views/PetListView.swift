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
            .navigationTitle("Pets")
            .navigationDestination(for: Pet.self) { pet in
                PetDetailView(pet: pet)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add Pet", systemImage: "plus") {
                        isAddingPet = true
                    }
                }
            }
            .overlay {
                if pets.isEmpty {
                    ContentUnavailableView(
                        "No Pets",
                        systemImage: "pawprint",
                        description: Text("Add a pet to start a diary.")
                    )
                }
            }
            .sheet(isPresented: $isAddingPet) {
                AddPetView()
            }
            #if DEBUG
            .onAppear { DemoData.seedIfRequested(in: modelContext) }
            #endif
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
                TextField("Name", text: $name)
                TextField("Species and breed", text: $species)
                Toggle("Add birth date", isOn: $hasBirthDate)
                if hasBirthDate {
                    DatePicker("Birth date", selection: $birthDate, displayedComponents: .date)
                }
            }
            .navigationTitle("New Pet")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
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
