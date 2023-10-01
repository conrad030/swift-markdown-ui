import SwiftUI

extension Sequence where Element == InlineNode {
    func renderText(
        baseURL: URL?,
        textStyles: InlineTextStyles,
        images: [String: UIImage],
        attributes: AttributeContainer
    ) -> AttributedString {
        var renderer = TextInlineRenderer(
            baseURL: baseURL,
            textStyles: textStyles,
            images: images,
            attributes: attributes
        )
        renderer.render(self)
        return renderer.result
    }
}

private struct TextInlineRenderer {
    var result = AttributedString("")
    
    private let baseURL: URL?
    private let textStyles: InlineTextStyles
    private let images: [String: UIImage]
    private let attributes: AttributeContainer
    private var shouldSkipNextWhitespace = false
    
    init(
        baseURL: URL?,
        textStyles: InlineTextStyles,
        images: [String: UIImage],
        attributes: AttributeContainer
    ) {
        self.baseURL = baseURL
        self.textStyles = textStyles
        self.images = images
        self.attributes = attributes
    }
    
    mutating func render<S: Sequence>(_ inlines: S) where S.Element == InlineNode {
        for inline in inlines {
            self.render(inline)
        }
    }
    
    private mutating func render(_ inline: InlineNode) {
        switch inline {
        case .text(let content):
            self.renderText(content)
        case .softBreak:
            self.renderSoftBreak()
        case .html(let content):
            self.renderHTML(content)
        case .image(let source, _):
            self.renderImage(source)
        default:
            self.defaultRender(inline)
        }
    }
    
    private mutating func renderText(_ text: String) {
        var text = text
        
        if self.shouldSkipNextWhitespace {
            self.shouldSkipNextWhitespace = false
            text = text.replacingOccurrences(of: "^\\s+", with: "", options: .regularExpression)
        }
        
        self.defaultRender(.text(text))
    }
    
    private mutating func renderSoftBreak() {
        if self.shouldSkipNextWhitespace {
            self.shouldSkipNextWhitespace = false
        } else {
            self.defaultRender(.softBreak)
        }
    }
    
    private mutating func renderHTML(_ html: String) {
        let tag = HTMLTag(html)
        
        switch tag?.name.lowercased() {
        case "br":
            self.defaultRender(.lineBreak)
            self.shouldSkipNextWhitespace = true
        default:
            self.defaultRender(.html(html))
        }
    }
    
    private mutating func renderImage(_ source: String) {
        if let image = self.images[source] {
            let attachment = NSTextAttachment()
            attachment.image = image
            attachment.setImageHeight(height: image.size.height / 3)
            
            let imageString = NSAttributedString(attachment: attachment)
            result.append(AttributedString(imageString))
        }
    }
    
    private mutating func defaultRender(_ inline: InlineNode) {
        self.result =
        self.result
        + inline.renderAttributedString(
            baseURL: self.baseURL,
            textStyles: self.textStyles,
            attributes: self.attributes
        )
    }
}

extension NSTextAttachment {
    func setImageHeight(height: CGFloat) {
        guard let image = image else { return }
        let ratio = image.size.width / image.size.height
        
        bounds = CGRect(x: bounds.origin.x, y: height / -3, width: ratio * height, height: height)
    }
}
