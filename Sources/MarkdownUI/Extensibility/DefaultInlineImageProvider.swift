import NetworkImage
import SwiftUI

/// The default inline image provider, which loads images from the network.
public struct DefaultInlineImageProvider: InlineImageProvider {
    public func image(with url: URL, label: String) async throws -> UIImage {
        try await UIImage(cgImage: DefaultNetworkImageLoader.shared.image(from: url),
                          scale: 1,
                          orientation: .up)
    }
}

extension InlineImageProvider where Self == DefaultInlineImageProvider {
    /// The default inline image provider, which loads images from the network.
    ///
    /// Use the `markdownInlineImageProvider(_:)` modifier to configure
    /// this image provider for a view hierarchy.
    public static var `default`: Self {
        .init()
    }
}
