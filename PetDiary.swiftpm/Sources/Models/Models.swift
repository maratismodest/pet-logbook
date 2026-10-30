import Foundation
import SwiftData

/// Тип записи в дневнике питомца.
enum EntryKind: String, Codable, CaseIterable, Identifiable {
    case feeding
    case walk
    case symptom
    case medication
    case vaccination

    var id: String { rawValue }

    var title: String {
        switch self {
        case .feeding: "Feeding"
        case .walk: "Walk"
        case .symptom: "Symptom"
        case .medication: "Medication"
        case .vaccination: "Vaccination"
        }
    }

    var systemImage: String {
        switch self {
        case .feeding: "fork.knife"
        case .walk: "figure.walk"
        case .symptom: "stethoscope"
        case .medication: "pills"
        case .vaccination: "syringe"
        }
    }
}

@Model
final class Pet {
    var name: String
    var species: String
    var birthDate: Date?
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \Entry.pet)
    var entries: [Entry] = []

    init(name: String, species: String, birthDate: Date? = nil) {
        self.name = name
        self.species = species
        self.birthDate = birthDate
        self.createdAt = .now
    }
}

@Model
final class Entry {
    var date: Date
    // Храним сырое значение, чтобы тип записи можно было использовать в предикатах SwiftData.
    var kindRaw: String
    var note: String
    var durationMinutes: Int?
    var grams: Int?
    var pet: Pet?

    var kind: EntryKind {
        get { EntryKind(rawValue: kindRaw) ?? .symptom }
        set { kindRaw = newValue.rawValue }
    }

    init(
        kind: EntryKind,
        date: Date = .now,
        note: String = "",
        durationMinutes: Int? = nil,
        grams: Int? = nil
    ) {
        self.kindRaw = kind.rawValue
        self.date = date
        self.note = note
        self.durationMinutes = durationMinutes
        self.grams = grams
    }

    /// Короткая строка с деталями: длительность, граммы.
    var detailText: String? {
        var parts: [String] = []
        if let durationMinutes { parts.append("\(durationMinutes) min") }
        if let grams { parts.append("\(grams) g") }
        return parts.isEmpty ? nil : parts.joined(separator: " · ")
    }
}
