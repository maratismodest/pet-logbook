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
                Picker("Period", selection: $period) {
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
        .navigationTitle("Vet Summary")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                if let pdfURL {
                    ShareLink(item: pdfURL) {
                        Label("Share PDF", systemImage: "square.and.arrow.up")
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
            Text("No entries for this period.")
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
                    Label(summary == nil ? "Write Summary" : "Rewrite Summary", systemImage: "sparkles")
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
            errorMessage = "Couldn't write the summary. \(ModelAvailability.message(for: error)) The facts below don't depend on the model."
        }
    }

    /// PDF готовится заранее, чтобы кнопка «Поделиться» работала сразу.
    private func exportPDF() {
        let fileName = "Vet Summary – \(pet.name)"
        pdfURL = try? PDFExporter.export(
            VetReportContent(digest: digest, summary: summary),
            fileName: fileName
        )
    }
}
