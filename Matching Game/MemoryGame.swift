//
//  MemoryGame.swift
//  Matching Game
//
//  Created by Stanley Moukh on 6/18/21.
//

import Foundation


struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?{
        get{
            cards.indices.filter { cards[$0].isFaceUp}.only}
        
        
        set{
            for index in cards.indices{
                cards[index].isFaceUp = index == newValue
                
            }
        }
    }
    
    mutating func choose(card: Card){
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp,!cards[chosenIndex].isMatched{
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard{
                if cards[chosenIndex].Content == cards[potentialMatchIndex].Content{
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                self.cards[chosenIndex].isFaceUp = !self.cards[chosenIndex].isFaceUp
            }else{
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            
            
        }
    }
        
        
        init(pairs: Int, cardContentFactory: (Int) -> CardContent) {
            cards = Array<Card>()
            for pairIndex in 0..<pairs {
                
                let content = cardContentFactory(pairIndex)
                cards.append(Card(Content: content, id: pairIndex*2))
                cards.append(Card(Content: content, id: pairIndex*2+1))
            }
            cards.shuffle()
        }
        
        struct Card: Identifiable {
            var isFaceUp: Bool = false{
                didSet{
                    if isFaceUp{
                        startUsingBonusTime()
                    }
                    else{
                        stopUsingBonusTime()
                    }
                }
            }
            var isMatched: Bool = false{
                didSet {
                    stopUsingBonusTime()
                    }
            }
            var Content: CardContent
            var id: Int
            
        
            
            
            
            
            
            var bonusTimeLimit : TimeInterval = 6
            
            private var faceUpTime: TimeInterval{
                if let lastFaceUpDate = self.lastFaceUpDate {
                    return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
                }
                else{
                    return pastFaceUpTime
                }
            }
            var lastFaceUpDate: Date?
            
            var pastFaceUpTime : TimeInterval = 0
            
            var bonusTimeRemaining: TimeInterval{
                max (0, bonusTimeLimit-faceUpTime)
            }
            var bonusRemaining: Double{
                (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
            }
            
            
            var hasEarnedBonus: Bool {
                isMatched && bonusTimeRemaining > 0
            }
            var isComsumingBonusTime : Bool{
                isFaceUp && !isMatched && bonusTimeRemaining > 0
            }
            
            private mutating func startUsingBonusTime(){
                if isComsumingBonusTime, lastFaceUpDate == nil{
                    lastFaceUpDate = Date()
                }
            }
            private mutating func stopUsingBonusTime(){
                pastFaceUpTime = faceUpTime
                self.lastFaceUpDate = nil
            }
        }
}
