import SwiftUI

/// Рендерит SwiftUI-вид в PDF через `ImageRenderer`.
/// Текст в PDF остаётся векторным, его можно выделять и искать.
@MainActor
enum PDFExporter {
    /// Ширина страницы A4 в точках.
    private static let pageWidth: CGFloat = 595
    private static let margin: CGFloat = 40

    /// Рендерит вид на одну страницу шириной A4 и высотой по содержимому.
    static func export(_ content: some View, fileName: String) throws -> URL {
        let page = content
            .padding(margin)
            .frame(width: pageWidth)
            .background(.white)
            .environment(\.colorScheme, .light)

        let renderer = ImageRenderer(content: page)
        renderer.proposedSize = ProposedViewSize(width: pageWidth, height: nil)

        let url = FileManager.default.temporaryDirectory.appending(path: "\(fileName).pdf")
        var renderError: Error?

        renderer.render { size, draw in
            var mediaBox = CGRect(origin: .zero, size: size)
            guard let consumer = CGDataConsumer(url: url as CFURL),
                  let context = CGContext(consumer: consumer, mediaBox: &mediaBox, nil)
            else {
                renderError = CocoaError(.fileWriteUnknown)
                return
            }
            context.beginPDFPage(nil)
            draw(context)
            context.endPDFPage()
            context.closePDF()
        }

        if let renderError { throw renderError }
        return url
    }
}
