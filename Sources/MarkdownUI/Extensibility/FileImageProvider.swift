//
//  FileImageProvider.swift
//  
//
//  Created by Conrad Felgentreff on 03.10.23.
//

import SwiftUI

public struct FileImageProvider: ImageProvider {
    private let name: (URL) -> String
    private let bundle: Bundle?
    
    /// Creates an asset image provider.
    /// - Parameters:
    ///   - name: A closure that extracts the image resource name from the URL in the Markdown content.
    ///   - bundle: The bundle where the image resources are located. Specify `nil` to search the app’s main bundle.
    public init(
        name: @escaping (URL) -> String = \.lastPathComponent,
        bundle: Bundle? = nil
    ) {
        self.name = name
        self.bundle = bundle
    }
    
    public func makeImage(url: URL?) -> some View {
        if let url = url, let image = self.image(url: url) {
            ResizeToFit(idealSize: CGSize(width: image.size.width / 3, height: image.size.height / 3)) {
                Image(platformImage: image)
                    .resizable()
            }
        }
    }
    
    private func image(url: URL) -> PlatformImage? {
        let image = UIImage(contentsOfFile: url.absoluteString) ?? UIImage()
//        try? FileManager.default.removeItem(atPath: url.absoluteString)
        return image
    }
}

extension ImageProvider where Self == FileImageProvider {
    /// An image provider that loads images from resources located in an app or a module.
    ///
    /// Use the `markdownImageProvider(_:)` modifier to configure this image provider for a view hierarchy.
    public static var file: Self {
        .init()
    }
}

#if canImport(UIKit)
private typealias PlatformImage = UIImage
#elseif os(macOS)
private typealias PlatformImage = NSImage
#endif

extension Image {
    fileprivate init(platformImage: PlatformImage) {
#if canImport(UIKit)
        self.init(uiImage: platformImage)
#elseif os(macOS)
        self.init(nsImage: platformImage)
#endif
    }
}
