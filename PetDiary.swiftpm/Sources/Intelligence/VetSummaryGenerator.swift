import Foundation
import FoundationModels

/// Часть сводки, которую пишет модель. Факты и цифры сюда не входят:
/// их считает `DiaryDigest`, чтобы модель не могла их исказить.
@Generable
struct VetSummary {
    @Guide(description: "Two or three sentences about the pet's condition over the period, based only on the diary entries")
    var overview: String

    @Guide(description: "Recurring or notable symptoms and changes, without diagnoses", .maximumCount(5))
    var concerns: [String]

    @Guide(description: "Questions the owner should ask the vet", .maximumCount(5))
    var questionsForVet: [String]
}

@MainActor
struct VetSummaryGenerator {
    func generate(from digest: DiaryDigest) async throws -> VetSummary {
        try ModelAvailability.requireAvailable()

        let session = LanguageModelSession {
            """
            You help a pet owner prepare for a vet visit.
            Briefly describe what happened with the pet, based on the diary entries.
            Use only the data from the entries and don't invent anything.
            Don't diagnose and don't recommend treatment.
            Look for patterns: the same symptom repeating, or symptoms that relate \
            to feeding, medications, or walks.
            If there are only a few entries, say so.
            """
        }

        let response = try await session.respond(
            to: digest.promptText,
            generating: VetSummary.self
        )
        return response.content
    }
}
