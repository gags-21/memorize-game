//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Gagan Bhirangi on 14/10/22.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    @Namespace private var dealingNameSpace
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
            gameBody
            HStack{
                shuffle
                Spacer()
                restart
            }
            .padding(.horizontal)
            }
            deckBody
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
    
    private func dealAnimation (for card: EmojiMemoryGame.Card) -> Animation {
        var delay: Double = 0.0
        if let index = game.cards.firstIndex(where: {$0.id == card.id}) {
            delay = Double(index) * ( CardConstants.totalDealDuration /  Double(game.cards.count) )
        }
        
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: CardConstants.aspectRatio )
        {card in
            if isUndealt(card) || ( card.isMatched && !card.isFaceUp ) {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation{
                            game.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(CardConstants.color)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            for card in game.cards{
                withAnimation(dealAnimation(for: card)) {
                        dealt(card)
                }
            }
        }
    }
    
    var shuffle: some View {
        Button("Mix IT"){
            withAnimation(Animation.easeInOut(duration: 1)){game.shuffle()}
        }
    }
    
    var restart: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                game.restart()
            }
        }
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 1
        static let undealtHeight: CGFloat = 90
        static let undealWidth = undealtHeight * aspectRatio
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
        return EmojiMemoryGameView(game: game)
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.portrait)
        //        EmojiMemoryGameView(game: game)
        //            .preferredColorScheme(.light)
        
    }
}
