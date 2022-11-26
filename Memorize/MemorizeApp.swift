//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Gagan Bhirangi on 14/10/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
