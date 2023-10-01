//
//  LatexView.swift
//  Demo
//
//  Created by Conrad Felgentreff on 15.09.23.
//

import SwiftUI
import MarkdownUI

struct LatexView: View {
    
    let content = """
          Hier steht Markdown: $x=\\frac{-b\\pm\\sqrt{b^2-4ac}}{2a}$, aber ich kann auch immer noch ganz andere Sachen dazu **schreiben**! Ich schreibe zur Sicherheit auch ~noch~ mehr _rein_, damit man gucken kann ob es klappt.
          
          # Szene Aufttakt 2. Teil
          ## Der Rabe
          """
    
    var body: some View {
        
        DemoView {
            
            Markdown(self.content)
        }
    }
}
