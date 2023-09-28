//
//  FileInlineImageProvider.swift
//  Demo
//
//  Created by Conrad Felgentreff on 22.09.23.
//

import SwiftUI

public struct FileInlineImageProvider: InlineImageProvider {
  private let name: (URL) -> String
  private let bundle: Bundle?

  /// Creates an asset inline image provider.
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

  public func image(with url: URL, label: String) async throws -> UIImage {
      return UIImage(contentsOfFile: url.absoluteString) ?? UIImage()
  }
}

extension InlineImageProvider where Self == FileInlineImageProvider {
  /// An inline image provider that loads images from resources located in an app or a module.
  ///
  /// Use the `markdownInlineImageProvider(_:)` modifier to configure this image provider for a view hierarchy.
  public static var file: Self {
    .init()
  }
}
