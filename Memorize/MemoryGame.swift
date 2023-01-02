//
//  MemoryGame.swift
//  Memorize
//
//  Created by Gagan Bhirangi on 20/10/22.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card>
    
    private var indexOfOnlyCard: Int? {
        get { cards.indices.filter({cards[$0].isFaceUp}).onlyOne }
        set { cards.indices.forEach{ cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    mutating func shuffle () {
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatch = indexOfOnlyCard {
                if cards[chosenIndex].content == cards[potentialMatch].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatch].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
//                for index in cards.indices {
//                    cards[index].isFaceUp = false
//                }
                indexOfOnlyCard = chosenIndex
            }
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
        cards.shuffle()
    }
    
    struct Card : Identifiable{
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        let content: CardContent
        let id: Int



// Mark: - Bonus Time

var bonusTimeLimit: TimeInterval = 6

private var faceUpTime: TimeInterval {
    if let lastFaceUpDate = self.lastFaceUpDate {
        return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
    } else {
        return pastFaceUpTime
    }
}

var lastFaceUpDate: Date?

var pastFaceUpTime: TimeInterval = 0

var bonusTimeRemaining: TimeInterval {
    max(0, bonusTimeLimit - faceUpTime)
}

var bonusRemaining: Double {
    (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
}

var hasEarnedBonus: Bool {
    isMatched && bonusTimeRemaining > 0
}

var isConsumingBonusTime: Bool {
    isFaceUp && !isMatched && bonusTimeRemaining > 0
}

private mutating func startUsingBonusTime() {
    if isConsumingBonusTime, lastFaceUpDate == nil {
        lastFaceUpDate = Date()
    }
}

private mutating func stopUsingBonusTime() {
    pastFaceUpTime = faceUpTime
    self.lastFaceUpDate = nil
}
    }
}

extension Array {
    var onlyOne: Element? {
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}

