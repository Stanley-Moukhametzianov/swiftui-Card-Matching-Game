
# swiftui-Card-Matching-Game

* App using Swift 5, to create a card memory game. The user can only have two cards filped over at the same time. When a 
card is flipped over a timer starts forcing the player to match the cards quickly. Once a card is matched the card disapperars. After, the 
game is over the user can press a restart button to play again. 

## :page_facing_up: Table of contents

* [ Swiftui-NASA-Mars-Rover-Images-App](#zap-Swiftui-NASA-Mars-Rover-Images-App)
  * [:page_facing_up: Table of contents](#page_facing_up-table-of-contents)
  * [:books: General info](#books-general-info)
  * [:camera: Screenshots](#camera-screenshots)
  * [:computer: Code Examples](#computer-code-examples)
  * [:file_folder: License](#file_folder-license)
  * [:envelope: Contact](#envelope-contact)

## :books: General info

* This mobile app was created following the MVVM framework. The Model is responsible for creating the cards, and controlling the logic 
involved in matching the cards. 


## :camera: Screenshots
<img align="left" width="300" height="600" src="https://github.com/Stanley-Moukhametzianov/swiftui-Card-Matching-Game/blob/MatchingGame/Matching%20Game.gif">
<p float="left">
  <img width="400" alt="Screen Shot 2021-07-22 at 3 54 39 PM" src="https://user-images.githubusercontent.com/66892566/126701464-c9057dcf-bbed-4572-ae99-6d49a4462fc2.png">
  
  
</p>

## :computer: Code Examples

* ` MemoryGame.swift` extract: checks if the cards that the user selected are matching and if they are, the cards are removed from the screen. 
Additionally, the file also controls the time limit that the user has. 

```swift

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


```


## :file_folder: License

* This project is licensed under the terms of the MIT license.

## :envelope: Contact

* Repo created by [Stanley Moukhametzianov](https://github.com/Stanley-Moukhametzianov?tab=repositories), email: stanleymoukh@gmail.com
