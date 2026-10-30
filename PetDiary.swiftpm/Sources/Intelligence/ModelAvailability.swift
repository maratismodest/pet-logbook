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
            return "Turn on Apple Intelligence in Settings to use smart features."
        case .unavailable(.deviceNotEligible):
            return "This device doesn't support Apple Intelligence."
        case .unavailable(.modelNotReady):
            return "The model is still downloading. Try again a little later."
        case .unavailable:
            return "The model isn't available right now."
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
                return "The model declined to process this text due to safety rules. Try rephrasing it."
            case .contextSizeExceeded:
                return "There are too many entries for one request. Choose a shorter period."
            case .unsupportedLanguageOrLocale:
                return "The model doesn't support the language of this text."
            default:
                break
            }
        }
        return "The model couldn't process the request. Try again later."
    }
}
