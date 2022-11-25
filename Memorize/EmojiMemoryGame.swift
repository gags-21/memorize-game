//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Gagan Bhirangi on 20/10/22.
//

import SwiftUI

class EmojiMemoryGame{
    
    static var emojis = ["🚌","🚀","✈️","🚗","🚝","🚖","🚊","⛵️","🚅","🚟","🏍","🛵","🛻","🛺","🏎","🚒","🚛","🚜","🚁"]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
                emojis[pairIndex]
            }
    }

    private var model: MemoryGame<String> = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
}
