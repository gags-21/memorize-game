//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Gagan Bhirangi on 20/10/22.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    typealias Card = MemoryGame<String>.Card
    
    private static var emojis = ["🚌","🚀","✈️","🚗","🚝","🚖","🚊","⛵️","🚅","🚟","🏍","🛵","🛻","🛺","🏎","🚒","🚛","🚜","🚁"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    @Published private var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose (_ card: Card) {
        model.choose(card)
    }
}
