import SwiftUI

struct InlineText: View {
    @Environment(\.inlineImageProvider) private var inlineImageProvider
    @Environment(\.baseURL) private var baseURL
    @Environment(\.imageBaseURL) private var imageBaseURL
    @Environment(\.theme) private var theme
    
    @State private var inlineImages: [String: UIImage] = [:]
    @State private var viewWidth: CGFloat = 100
    
    private let inlines: [InlineNode]
    
    init(_ inlines: [InlineNode]) {
        self.inlines = inlines
    }
    
    var body: some View {
        TextStyleAttributesReader { attributes in
            
            AttributedStringView(attributedString: self.inlines.renderText(
                baseURL: self.baseURL,
                textStyles: .init(
                    code: self.theme.code,
                    emphasis: self.theme.emphasis,
                    strong: self.theme.strong,
                    strikethrough: self.theme.strikethrough,
                    link: self.theme.link
                ),
                images: self.inlineImages,
                attributes: attributes
            ), viewWidth: self.$viewWidth)
        }
        .background {
                    
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                self.viewWidth = geometry.size.width
                            }
                    }
                }
        .task(id: self.inlines) {
            self.inlineImages = (try? await self.loadInlineImages()) ?? [:]
        }
    }
    
    private func loadInlineImages() async throws -> [String: UIImage] {
        let images = Set(self.inlines.compactMap(\.imageData))
        guard !images.isEmpty else { return [:] }
        
        return try await withThrowingTaskGroup(of: (String, UIImage).self) { taskGroup in
            for image in images {
                guard let url = URL(string: image.source, relativeTo: self.imageBaseURL) else {
                    continue
                }
                
                taskGroup.addTask {
                    (image.source, try await self.inlineImageProvider.image(with: url, label: image.alt))
                }
            }
            
            var inlineImages: [String: UIImage] = [:]
            
            for try await result in taskGroup {
                inlineImages[result.0] = result.1
            }
            
            return inlineImages
        }
    }
}

struct AttributedStringView: UIViewRepresentable {
    
    var attributedString: AttributedString
    @Binding var viewWidth: CGFloat
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.attributedText = self.convertToNSAttributedString(attributedString: self.attributedString)
        uiView.preferredMaxLayoutWidth = viewWidth
    }
    
    private func convertToNSAttributedString(attributedString: AttributedString) -> NSAttributedString {
        let nsAttributedString = NSMutableAttributedString(attributedString)
        return nsAttributedString
    }
}

extension AttributedString {
    func resolvingFonts() -> AttributedString {
        var output = self
        
        for run in output.runs {
            if let fontProperties = run.fontProperties {
                output[run.range].font = UIFont.withProperties(fontProperties)
                output[run.range].fontProperties = nil
            }
            if let foregroundColor = run.swiftUI.foregroundColor {
                output[run.range].foregroundColor = UIColor(foregroundColor)
            }
            if let backgroundColor = run.swiftUI.backgroundColor {
                output[run.range].backgroundColor = UIColor(backgroundColor)
            }
        }
        
        return output
    }
}
