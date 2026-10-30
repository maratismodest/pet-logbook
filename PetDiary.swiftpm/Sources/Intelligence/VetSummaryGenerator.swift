import Foundation
import FoundationModels

/// Часть сводки, которую пишет модель. Факты и цифры сюда не входят:
/// их считает `DiaryDigest`, чтобы модель не могла их исказить.
@Generable
struct VetSummary {
    @Guide(description: "Два-три предложения о состоянии питомца за период, только по фактам из записей")
    var overview: String

    @Guide(description: "Повторяющиеся или заметные симптомы и изменения, без диагнозов", .maximumCount(5))
    var concerns: [String]

    @Guide(description: "Вопросы, которые владельцу стоит задать ветеринару", .maximumCount(5))
    var questionsForVet: [String]
}

@MainActor
struct VetSummaryGenerator {
    func generate(from digest: DiaryDigest) async throws -> VetSummary {
        try ModelAvailability.requireAvailable()

        let session = LanguageModelSession {
            """
            Ты помогаешь владельцу подготовиться к визиту к ветеринару.
            По записям дневника кратко опиши, что происходило с питомцем.
            Опирайся только на данные из записей, ничего не придумывай.
            Не ставь диагнозов и не назначай лечение.
            Замечай повторы: один и тот же симптом несколько раз, связь симптомов \
            с кормлением, лекарствами или прогулками.
            Если записей мало, так и скажи.
            Пиши по-русски.
            """
        }

        let response = try await session.respond(
            to: digest.promptText,
            generating: VetSummary.self
        )
        return response.content
    }
}
