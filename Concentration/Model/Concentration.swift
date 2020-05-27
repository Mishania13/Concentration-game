//
//  ConcentrationModel.swift
//  Concentration
//
//  Created by Mr. Bear on 21.05.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import Foundation

class Concentration {
    
    var cards = [Card]()
    
    var onlyOneFacedUpCard: Int?

    var score = 0
     
    lazy var numberOfMatched = cards.count
    
    let startTime = Date()
    
    func chooseCard(at index: Int) {
        
        if !cards[index].isMatched {
            
            if let matchedIndex = onlyOneFacedUpCard, matchedIndex != index {
                
                if cards[matchedIndex].identifire == cards[index].identifire {
                    
                    cards[matchedIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 3
                    numberOfMatched -= 2
                }
                cards[index].isFaceUp = true
                onlyOneFacedUpCard = nil
                score -= 1

            } else {
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                onlyOneFacedUpCard = index
                score -= 1
            }
        }
    }
    
    init(numberOfPairsCards: Int) {
        for _ in 1...numberOfPairsCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}
