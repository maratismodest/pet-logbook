import SwiftUI

/// Содержимое сводки. Один и тот же вид показывается на экране и рендерится в PDF.
struct VetReportContent: View {
    let digest: DiaryDigest
    let summary: VetSummary?

    private let dateFormat = Date.FormatStyle.dateTime.day().month(.wide).year()
    private let dateTimeFormat = Date.FormatStyle.dateTime.day().month(.twoDigits).hour().minute()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            header

            if let summary {
                section("Кратко") {
                    Text(summary.overview)
                }
                if !summary.concerns.isEmpty {
                    section("На что обратить внимание") {
                        bulletList(summary.concerns)
                    }
                }
            }

            section("Питание и активность") {
                Text(digest.feedingText)
                Text(digest.walkText)
            }

            section("Симптомы") {
                datedList(digest.symptoms, empty: "Не отмечались")
            }

            section("Лекарства") {
                datedList(digest.medications, empty: "Не давались")
            }

            section("Прививки (за всё время)") {
                datedList(digest.vaccinations, empty: "Нет записей", format: dateFormat)
            }

            if let summary, !summary.questionsForVet.isEmpty {
                section("Вопросы врачу") {
                    bulletList(summary.questionsForVet)
                }
            }

            Text("Сводка составлена по записям владельца и не является медицинским заключением.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(digest.petName)
                .font(.largeTitle.bold())
            Text([digest.species, digest.ageText].compactMap { $0 }.filter { !$0.isEmpty }.joined(separator: " · "))
                .foregroundStyle(.secondary)
            Text("\(digest.start.formatted(dateFormat)) – \(digest.end.formatted(dateFormat))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            content()
        }
    }

    private func bulletList(_ items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(items, id: \.self) { item in
                Text("• \(item)")
            }
        }
    }

    private func datedList(_ lines: [DiaryDigest.Line], empty: String, format: Date.FormatStyle? = nil) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if lines.isEmpty {
                Text(empty)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(lines) { line in
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(line.date.formatted(format ?? dateTimeFormat))
                            .font(.subheadline.monospacedDigit())
                            .foregroundStyle(.secondary)
                        Text(line.text)
                    }
                }
            }
        }
    }
}
