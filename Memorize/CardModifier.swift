//
//  CardModifier.swift
//  Memorize
//
//  Created by Gagan Bhirangi on 10/12/22.
//

import SwiftUI

struct CardModifier: AnimatableModifier {
    init(isFaceUp: Bool){
        rotationAngle = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get{rotationAngle}
        set{rotationAngle = newValue}
    }
    
    var rotationAngle: Double // degrees
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotationAngle < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            }  else {
                shape.fill()
            }
            content.opacity( rotationAngle<90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotationAngle), axis: (0,1,0))
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
