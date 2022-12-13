//
//  CardModifier.swift
//  Memorize
//
//  Created by Gagan Bhirangi on 10/12/22.
//

import SwiftUI

struct CardModifier: ViewModifier {
    var isFaceUp: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            }  else {
                shape.fill()
            }
            content.opacity( isFaceUp ? 1 : 0)
        }
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 15
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify (isFaceUp: Bool) -> some View{
        return self.modifier(CardModifier(isFaceUp: isFaceUp))
    }
}
