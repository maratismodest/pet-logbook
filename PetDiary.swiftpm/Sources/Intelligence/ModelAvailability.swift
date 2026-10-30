import Foundation
import FoundationModels

/// Общая проверка доступности модели на устройстве.
enum ModelAvailability {
    struct UnavailableError: LocalizedError {
        let reason: String
        var errorDescription: String? { reason }
    }

    /// Человекочитаемая причина, если модель недоступна; `nil`, если всё готово.
    static var unavailableReason: String? {
        switch SystemLanguageModel.default.availability {
        case .available:
            return nil
        case .unavailable(.appleIntelligenceNotEnabled):
            return "Включите Apple Intelligence в Настройках, чтобы пользоваться функциями на основе модели."
        case .unavailable(.deviceNotEligible):
            return "Это устройство не поддерживает Apple Intelligence."
        case .unavailable(.modelNotReady):
            return "Модель ещё загружается. Попробуйте чуть позже."
        case .unavailable:
            return "Модель сейчас недоступна."
        }
    }

    /// Бросает ошибку с понятным текстом, если модель недоступна.
    static func requireAvailable() throws {
        if let reason = unavailableReason {
            throw UnavailableError(reason: reason)
        }
    }

    /// Понятное пользователю описание ошибки генерации.
    /// Полная ошибка пишется в консоль для отладки.
    static func message(for error: Error) -> String {
        print("Foundation Models error: \(error)")

        if let error = error as? UnavailableError {
            return error.reason
        }
        if let error = error as? LanguageModelError {
            switch error {
            case .guardrailViolation, .refusal:
                return "Модель отказалась обрабатывать этот текст из-за правил безопасности. Попробуйте переформулировать."
            case .contextSizeExceeded:
                return "Записей слишком много для одного запроса. Выберите период покороче."
            case .unsupportedLanguageOrLocale:
                return "Модель не поддерживает язык этого текста."
            default:
                break
            }
        }
        return "Модель не смогла обработать запрос. Попробуйте ещё раз позже."
    }
}
