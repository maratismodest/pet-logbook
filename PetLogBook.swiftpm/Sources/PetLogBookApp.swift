import SwiftUI
import SwiftData

@main
struct PetLogBookApp: App {
    var body: some Scene {
        WindowGroup {
            PetListView()
        }
        .modelContainer(for: [Pet.self, Entry.self])
    }
}
