//
//  MarkdownTestView.swift
//  Demo
//
//  Created by Conrad Felgentreff on 28.09.23.
//

import SwiftUI
import MarkdownUI

struct MarkdownTestView: View {
    
    let content = """
      Das ist **Fett**
      """
    
    var body: some View {
        
        DemoView {
            
            Markdown(self.content)
        }
    }
}
