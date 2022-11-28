//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Gagan Bhirangi on 14/10/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
