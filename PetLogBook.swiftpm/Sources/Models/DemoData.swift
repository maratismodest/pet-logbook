#if DEBUG
import Foundation
import SwiftData

/// Демо-данные для скриншотов App Store. Только в отладочной сборке:
/// запускаются аргументом `-seedDemoData` и только если база пуста.
enum DemoData {
    static func seedIfRequested(in context: ModelContext) {
        guard ProcessInfo.processInfo.arguments.contains("-seedDemoData") else { return }
        let existing = (try? context.fetchCount(FetchDescriptor<Pet>())) ?? 0
        guard existing == 0 else { return }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        func date(daysAgo: Int, hour: Int, minute: Int = 0) -> Date {
            let day = calendar.date(byAdding: .day, value: -daysAgo, to: today) ?? today
            return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: day) ?? day
        }

        let max = Pet(
            name: "Max",
            species: "Dog, Golden Retriever",
            birthDate: calendar.date(byAdding: .month, value: -40, to: today)
        )
        let luna = Pet(
            name: "Luna",
            species: "Cat, British Shorthair",
            birthDate: calendar.date(byAdding: .month, value: -18, to: today)
        )
        context.insert(max)
        context.insert(luna)

        // Две недели обычной жизни Макса: кормления утром и вечером, прогулки.
        for day in 0..<14 {
            max.entries.append(Entry(kind: .feeding, date: date(daysAgo: day, hour: 8), note: "Dry food", grams: 180))
            max.entries.append(Entry(kind: .feeding, date: date(daysAgo: day, hour: 19), note: "Dry food", grams: 170))
            let minutes = [45, 30, 60, 40, 35, 50, 30][day % 7]
            max.entries.append(Entry(kind: .walk, date: date(daysAgo: day, hour: 7, minute: 15), note: "Morning walk in the park", durationMinutes: minutes))
            if day % 2 == 0 {
                max.entries.append(Entry(kind: .walk, date: date(daysAgo: day, hour: 20, minute: 30), note: "Evening walk", durationMinutes: 25))
            }
        }

        max.entries.append(Entry(kind: .symptom, date: date(daysAgo: 9, hour: 21), note: "Scratching left ear"))
        max.entries.append(Entry(kind: .symptom, date: date(daysAgo: 6, hour: 18, minute: 30), note: "Scratching left ear, slight redness"))
        max.entries.append(Entry(kind: .symptom, date: date(daysAgo: 2, hour: 9), note: "Shaking head after walk"))
        max.entries.append(Entry(kind: .medication, date: date(daysAgo: 5, hour: 9), note: "Ear drops, 3 drops in left ear"))
        max.entries.append(Entry(kind: .medication, date: date(daysAgo: 1, hour: 9), note: "Deworming tablet"))
        max.entries.append(Entry(kind: .vaccination, date: date(daysAgo: 120, hour: 11), note: "Rabies"))
        max.entries.append(Entry(kind: .vaccination, date: date(daysAgo: 120, hour: 11, minute: 10), note: "DHPP booster"))

        for day in 0..<7 {
            luna.entries.append(Entry(kind: .feeding, date: date(daysAgo: day, hour: 8, minute: 30), note: "Wet food", grams: 85))
        }
        luna.entries.append(Entry(kind: .vaccination, date: date(daysAgo: 200, hour: 10), note: "FVRCP"))
    }
}
#endif
