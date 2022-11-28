//
//  MemoryGame.swift
//  Memorize
//
//  Created by Gagan Bhirangi on 20/10/22.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card>
    
    private var indexOfOnlyCard: Int?
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatch = indexOfOnlyCard {
                if cards[chosenIndex].content == cards[potentialMatch].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatch].isMatched = true
                }
                indexOfOnlyCard = nil
            } else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                indexOfOnlyCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        // add numberofPairsOfCards x 2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2 + 1))
        }
    }
    
    struct Card : Identifiable{
        var isFaceUp = false
        var isMatched = false
        let content: CardContent
        let id: Int
    }
}
