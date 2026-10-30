import Foundation

/// Период, за который строится сводка.
enum ReportPeriod: Int, CaseIterable, Identifiable {
    case week = 7
    case month = 30
    case quarter = 90

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .week: "7 дней"
        case .month: "30 дней"
        case .quarter: "90 дней"
        }
    }
}

/// Факты из дневника за период. Всё считается обычным кодом,
/// поэтому эта часть сводки точна и работает без модели.
struct DiaryDigest {
    struct Line: Identifiable {
        let id = UUID()
        let date: Date
        let text: String
    }

    let petName: String
    let species: String
    let birthDate: Date?
    let start: Date
    let end: Date
    let days: Int

    let feedingCount: Int
    let totalGrams: Int
    /// Сколько кормлений с указанным весом: среднее считаем только по ним.
    let feedingsWithGrams: Int
    let walkCount: Int
    let totalWalkMinutes: Int
    /// Сколько прогулок с указанной длительностью: среднее считаем только по ним.
    let walksWithDuration: Int

    let symptoms: [Line]
    let medications: [Line]
    /// Прививки за всё время: врачу важна последняя дата, даже если она вне периода.
    let vaccinations: [Line]

    /// Лимиты строк в промпте, чтобы не выйти за контекстное окно модели.
    private static let promptSymptomLimit = 40
    private static let promptMedicationLimit = 25

    init(pet: Pet, period: ReportPeriod, now: Date = .now) {
        let calendar = Calendar.current
        let end = now
        let start = calendar.date(byAdding: .day, value: -period.rawValue, to: calendar.startOfDay(for: now)) ?? now

        let inPeriod = pet.entries
            .filter { $0.date >= start && $0.date <= end }
            .sorted { $0.date < $1.date }

        func lines(_ kind: EntryKind, from entries: [Entry]) -> [Line] {
            entries
                .filter { $0.kind == kind }
                .map { Line(date: $0.date, text: $0.note.isEmpty ? kind.title : $0.note) }
        }

        let feedings = inPeriod.filter { $0.kind == .feeding }
        let walks = inPeriod.filter { $0.kind == .walk }

        self.petName = pet.name
        self.species = pet.species
        self.birthDate = pet.birthDate
        self.start = start
        self.end = end
        self.days = period.rawValue
        self.feedingCount = feedings.count
        let grams = feedings.compactMap(\.grams)
        self.totalGrams = grams.reduce(0, +)
        self.feedingsWithGrams = grams.count
        self.walkCount = walks.count
        let minutes = walks.compactMap(\.durationMinutes)
        self.totalWalkMinutes = minutes.reduce(0, +)
        self.walksWithDuration = minutes.count
        self.symptoms = lines(.symptom, from: inPeriod)
        self.medications = lines(.medication, from: inPeriod)
        self.vaccinations = lines(.vaccination, from: pet.entries.sorted { $0.date < $1.date })
    }

    var isEmpty: Bool {
        feedingCount == 0 && walkCount == 0 && symptoms.isEmpty && medications.isEmpty
    }

    /// Средняя длительность одной прогулки. Делим на число прогулок, а не на дни периода:
    /// иначе одна прогулка за месяц выглядела бы как «1 мин в день».
    var averageWalkMinutes: Int? {
        walksWithDuration > 0 ? totalWalkMinutes / walksWithDuration : nil
    }

    /// Средняя порция за одно кормление.
    var averageGramsPerFeeding: Int? {
        feedingsWithGrams > 0 ? totalGrams / feedingsWithGrams : nil
    }

    var feedingText: String {
        var text = "Кормлений: \(feedingCount)"
        if let averageGramsPerFeeding { text += ", в среднем \(averageGramsPerFeeding) г за раз" }
        return text
    }

    var walkText: String {
        var text = "Прогулок: \(walkCount)"
        if let averageWalkMinutes { text += ", в среднем \(averageWalkMinutes) мин" }
        return text
    }

    var ageText: String? {
        guard let birthDate else { return nil }
        let components = Calendar.current.dateComponents([.year, .month], from: birthDate, to: end)
        let years = components.year ?? 0
        let months = components.month ?? 0
        if years > 0 { return "\(years) г. \(months) мес." }
        return "\(months) мес."
    }

    /// Компактный текст для модели: агрегаты вместо сырых записей кормления и прогулок,
    /// полные строки только для симптомов и лекарств.
    var promptText: String {
        let dateFormat = Date.FormatStyle.dateTime.day().month(.twoDigits).hour().minute()
        func render(_ lines: [Line], limit: Int) -> String {
            guard !lines.isEmpty else { return "нет" }
            // Берём самые свежие записи, если их больше лимита.
            let recent = lines.suffix(limit)
            var text = recent
                .map { "- \($0.date.formatted(dateFormat)): \($0.text)" }
                .joined(separator: "\n")
            if lines.count > limit {
                text = "(показаны последние \(limit) из \(lines.count))\n" + text
            }
            return text
        }

        return """
        Питомец: \(petName), \(species)\(ageText.map { ", возраст \($0)" } ?? "")
        Период: \(days) дней

        \(feedingText)
        \(walkText)

        Симптомы:
        \(render(symptoms, limit: Self.promptSymptomLimit))

        Лекарства:
        \(render(medications, limit: Self.promptMedicationLimit))
        """
    }
}
