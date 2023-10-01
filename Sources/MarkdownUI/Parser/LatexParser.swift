//
//  File.swift
//
//
//  Created by Conrad Felgentreff on 22.09.23.
//

import SwiftUI
import LaTeXSwiftUI

class LatexParser {
    
    @MainActor
    static func replaceDollarEnclosedStrings(in input: String) -> String {
        let regexPattern = "\\$(.*?)\\$"
        let regex = try! NSRegularExpression(pattern: regexPattern, options: [])
        
        var output = input
        let matches = regex.matches(in: input, options: [], range: NSRange(input.startIndex..., in: input))
        
        // Gehe rückwärts durch die Matches, damit die Ranges beim Ersetzen gültig bleiben
        for match in matches.reversed() {
            if let range = Range(match.range(at: 1), in: input) {
                let capturedString = String(input[range])
                let replacement = "![latex](\(self.parseLatexFromString(capturedString) ?? ""))"
                output = output.replacingCharacters(in: Range(match.range, in: output)!, with: replacement)
            }
        }
        
        return output
    }
    
    @MainActor
    /// Parses a Latex image from a sring and safes it to the file system.
    /// - Parameter string: The latex string.
    /// - Returns: The file name.
    static func parseLatexFromString(_ string: String) -> String? {
        let renderer = ImageRenderer(content: LaTeX("$\(string)$"))
        renderer.scale = 3
        guard let uiImage = renderer.uiImage else { return nil }
        return self.safeToFileSystem(uiImage: uiImage)
    }
    
    /// Safes a UIImage to the file system.
    /// - Parameter uiImage: The image of the latex view.
    /// - Returns: The file name.
    private static func safeToFileSystem(uiImage: UIImage) -> String? {
        // Create path.
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let imageName = UUID().uuidString
        let filePath = "\(paths[0])/\(imageName).png"
        
        // Save image.
        let filePathURL = URL(filePath: filePath)
        do {
            try uiImage.pngData()?.write(to: filePathURL)
        } catch let error {
            print(error.localizedDescription)
            
        }
        return filePath
    }
}
