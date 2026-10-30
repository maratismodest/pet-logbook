import Foundation
import FoundationModels

/// Тип события в том виде, в каком его генерирует модель.
@Generable
enum ParsedKind {
    case feeding
    case walk
    case symptom
    case medication
    case vaccination

    var entryKind: EntryKind {
        switch self {
        case .feeding: .feeding
        case .walk: .walk
        case .symptom: .symptom
        case .medication: .medication
        case .vaccination: .vaccination
        }
    }
}

@Generable
struct ParsedEntry {
    var kind: ParsedKind

    @Guide(description: "Short description of the event, without date or time")
    var note: String

    @Guide(description: "Duration in minutes, only if explicitly stated")
    var durationMinutes: Int?

    @Guide(description: "Amount of food in grams, only if explicitly stated")
    var grams: Int?

    @Guide(description: "Hour of the event from 0 to 23, only if a time is explicitly stated")
    var hourOfDay: Int?
}

@Generable
struct ParsedEntries {
    @Guide(description: "Every separate event mentioned in the owner's text")
    var entries: [ParsedEntry]
}

/// Превращает свободную фразу владельца в структурированные записи дневника.
/// Работает на главном акторе, потому что создаёт модели SwiftData,
/// которые нельзя передавать между акторами.
@MainActor
struct QuickEntryParser {
    func parse(_ text: String, petName: String) async throws -> [Entry] {
        try ModelAvailability.requireAvailable()

        // Новая сессия на каждый запрос: записи независимы, история не нужна.
        let session = LanguageModelSession {
            """
            You help keep a diary for a pet named \(petName).
            Split the owner's text into separate events: feeding, walk, \
            symptom, medication, or vaccination.
            Don't invent details that aren't in the text. Don't diagnose.
            """
        }

        let response = try await session.respond(
            to: text,
            generating: ParsedEntries.self
        )

        return response.content.entries.map { parsed in
            Entry(
                kind: parsed.kind.entryKind,
                date: Self.date(forHour: parsed.hourOfDay),
                note: parsed.note,
                durationMinutes: parsed.durationMinutes,
                grams: parsed.grams
            )
        }
    }

    /// Если модель указала час, ставим сегодняшнюю дату с этим часом, иначе текущее время.
    private static func date(forHour hour: Int?) -> Date {
        guard let hour, (0...23).contains(hour) else { return .now }
        let calendar = Calendar.current
        return calendar.date(bySettingHour: hour, minute: 0, second: 0, of: .now) ?? .now
    }
}
