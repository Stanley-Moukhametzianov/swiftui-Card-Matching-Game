//
//  EmojiMemoryGame.swift
//  Matching Game
//
//  Created by Stanley Moukh on 6/18/21.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject{
    static var rand = Int.random(in: 2...5)
    
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    
   private static func createMemoryGame() -> MemoryGame<String>{
        let emojis = ["👻","🤩","☠️","🥶","🤖"]
    return MemoryGame<String>(pairs : rand){ pairIndex in
        return emojis[pairIndex]
        }
    }
    
    
    //Mark: Access to the model
    var cards: Array<MemoryGame<String>.Card>{
        model.cards
    }
    //Mark: Intents
    func choose(card: MemoryGame<String>.Card){
        model.choose(card: card)
    }
    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }

    
}








