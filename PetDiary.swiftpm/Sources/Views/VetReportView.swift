import SwiftUI

/// Экран сводки для ветеринара: выбор периода, резюме от модели и экспорт в PDF.
struct VetReportView: View {
    let pet: Pet

    @State private var period: ReportPeriod = .month
    @State private var summary: VetSummary?
    @State private var isGenerating = false
    @State private var errorMessage: String?
    @State private var pdfURL: URL?

    private let generator = VetSummaryGenerator()

    private var digest: DiaryDigest {
        DiaryDigest(pet: pet, period: period)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Picker("Период", selection: $period) {
                    ForEach(ReportPeriod.allCases) { period in
                        Text(period.title).tag(period)
                    }
                }
                .pickerStyle(.segmented)

                summaryControls

                VetReportContent(digest: digest, summary: summary)
            }
            .padding()
        }
        .navigationTitle("Сводка для врача")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                if let pdfURL {
                    ShareLink(item: pdfURL) {
                        Label("Поделиться PDF", systemImage: "square.and.arrow.up")
                    }
                }
            }
        }
        .onChange(of: period) {
            // Резюме модели относится к старому периоду, поэтому сбрасываем его.
            summary = nil
            errorMessage = nil
            exportPDF()
        }
        .onAppear(perform: exportPDF)
    }

    @ViewBuilder
    private var summaryControls: some View {
        if let reason = ModelAvailability.unavailableReason {
            Label(reason, systemImage: "exclamationmark.triangle")
                .font(.footnote)
                .foregroundStyle(.secondary)
        } else if digest.isEmpty {
            Text("За этот период нет записей.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        } else {
            Button {
                Task { await generateSummary() }
            } label: {
                if isGenerating {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Label(summary == nil ? "Составить резюме" : "Составить заново", systemImage: "sparkles")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isGenerating)
        }

        if let errorMessage {
            Text(errorMessage)
                .font(.footnote)
                .foregroundStyle(.red)
        }
    }

    private func generateSummary() async {
        isGenerating = true
        errorMessage = nil
        defer { isGenerating = false }

        do {
            summary = try await generator.generate(from: digest)
            exportPDF()
        } catch {
            errorMessage = "Не удалось составить резюме. \(ModelAvailability.message(for: error)) Факты ниже от модели не зависят."
        }
    }

    /// PDF готовится заранее, чтобы кнопка «Поделиться» работала сразу.
    private func exportPDF() {
        let fileName = "Сводка — \(pet.name)"
        pdfURL = try? PDFExporter.export(
            VetReportContent(digest: digest, summary: summary),
            fileName: fileName
        )
    }
}
