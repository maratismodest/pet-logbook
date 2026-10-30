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

    @Guide(description: "Краткое описание события на русском, без даты и времени")
    var note: String

    @Guide(description: "Длительность в минутах, только если явно указана")
    var durationMinutes: Int?

    @Guide(description: "Количество корма в граммах, только если явно указано")
    var grams: Int?

    @Guide(description: "Час события от 0 до 23, только если время явно указано")
    var hourOfDay: Int?
}

@Generable
struct ParsedEntries {
    @Guide(description: "Все отдельные события, упомянутые во фразе пользователя")
    var entries: [ParsedEntry]
}

/// Превращает свободную фразу владельца в структурированные записи дневника.
/// Работает на главном акторе, потому что создаёт модели SwiftData,
/// которые нельзя передавать между акторами.
@MainActor
struct QuickEntryParser {
    enum ParserError: LocalizedError {
        case modelUnavailable(String)

        var errorDescription: String? {
            switch self {
            case .modelUnavailable(let reason): reason
            }
        }
    }

    /// Человекочитаемая причина, если модель недоступна; `nil`, если всё готово.
    static var unavailableReason: String? {
        switch SystemLanguageModel.default.availability {
        case .available:
            return nil
        case .unavailable(.appleIntelligenceNotEnabled):
            return "Включите Apple Intelligence в Настройках, чтобы пользоваться быстрой записью."
        case .unavailable(.deviceNotEligible):
            return "Это устройство не поддерживает Apple Intelligence. Добавляйте записи вручную."
        case .unavailable(.modelNotReady):
            return "Модель ещё загружается. Попробуйте чуть позже."
        case .unavailable:
            return "Модель сейчас недоступна."
        }
    }

    func parse(_ text: String, petName: String) async throws -> [Entry] {
        if let reason = Self.unavailableReason {
            throw ParserError.modelUnavailable(reason)
        }

        // Новая сессия на каждый запрос: записи независимы, история не нужна.
        let session = LanguageModelSession {
            """
            Ты помогаешь вести дневник питомца по кличке \(petName).
            Разбей фразу владельца на отдельные события: кормление, прогулка, \
            симптом, лекарство или прививка.
            Не придумывай данные, которых нет во фразе. Не ставь диагнозов.
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
