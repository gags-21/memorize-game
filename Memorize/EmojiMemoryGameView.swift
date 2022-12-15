//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Gagan Bhirangi on 14/10/22.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
        VStack{
            gameBody
            shuffle
        }
        .padding()
    }
    
    @State private var dealt = Set<Int>()
    
    private func dealt (_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt (_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3 )
        {card in
            if isUndealt(card) || ( card.isMatched && !card.isFaceUp ) {
                Color.clear
            } else {
                CardView(card: card)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .scale, removal: .opacity))
                    .onTapGesture {
                        withAnimation{
                            game.choose(card)
                        }
                    }
            }
        }
        .onAppear {
            withAnimation {
                for card in game.cards{
                        dealt(card)
                }
            }
        }
        .foregroundColor(.red)
    }
    
    var shuffle: some View {
        Button("Mix IT"){
            withAnimation(Animation.easeInOut(duration: 1)){game.shuffle()}
        }
    }
}

struct CardView: View{
    let card: EmojiMemoryGame.Card
    @State var animatedAngle: Double = 0
    
    var body: some View{
        GeometryReader{ geometry in
            ZStack {
                Pie(startAngle: Angle(degrees: 275), endAngle: Angle(degrees: 45))
                    .padding(5).opacity(0.5)
                Text(card.content)
                    .rotationEffect(Angle(degrees: card.isMatched ? 360 : 0))
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(size: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale(size: CGSize) -> CGFloat{
        min(size.width, size.height) / ( DrawingConstants.fontSize / DrawingConstants.fontScale )
    }
    
    private func fontSize (in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale )
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.6
        static let fontSize: CGFloat = 32
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.portrait)
        //        EmojiMemoryGameView(game: game)
        //            .preferredColorScheme(.light)
        
    }
}
