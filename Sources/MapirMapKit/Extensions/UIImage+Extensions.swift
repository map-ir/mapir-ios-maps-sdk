import Foundation
import UIKit

extension UIImage {
    static func drawPDFfromURL(url: URL?) -> UIImage? {
        guard let url = url,
              let document = CGPDFDocument(url as CFURL),
              let page = document.page(at: 1) else { return nil }

        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

            ctx.cgContext.drawPDFPage(page)
        }

        return img
    }

    @available(iOS, obsoleted: 13.0)
    static var logo: UIImage? {
        let url = Bundle.module.url(
            forResource: "map-logo-light",
            withExtension: "pdf"
        )
        return UIImage.drawPDFfromURL(url: url!)

    }

    @available(iOS 12.0, *)
    static func logo(_ interfaceStyle: UIUserInterfaceStyle = .light) -> UIImage? {
        let url = Bundle.module.url(
            forResource: "map-logo-\(interfaceStyle == .dark ? "dark" : "light")",
            withExtension: "pdf"
        )
        return UIImage.drawPDFfromURL(url: url!)
    }
}
