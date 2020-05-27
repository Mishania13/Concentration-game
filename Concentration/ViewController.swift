//
//  ViewController.swift
//  Concentration
//
//  Created by Mr. Bear on 20.05.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = Concentration(numberOfPairsCards: cardButtons.count/2)
    
    var themseOfCurrentGame = ""
    
    lazy var cardColor = (themses[themseOfCurrentGame]!)[1][0] as? UIColor ?? UIColor.white
    lazy var backGroundColor = (themses[themseOfCurrentGame]!)[2][0] as? UIColor ?? UIColor.white
    
    //first color for card, second for viewBackground, third for view backGround
    var themses = [
        "magic" : [["🧛🏻‍♂️", "🧙‍♂️", "🧟‍♂️", "🧞‍♂️", "🧜🏻‍♂️", "🧚🏻", "🦸🏻‍♂️", "🦹🏾", "🎅🏻", "👸"], [#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)], [#colorLiteral(red: 0.3638019562, green: 0.6142374873, blue: 0, alpha: 1)]],
        "profession" : [["👮🏻‍♀️", "👷🏼‍♂️", "💂🏿‍♂️", "🕵🏻‍♂️", "👨🏽‍⚕️", "🧑‍🌾", "👨🏻‍🍳", "👩🏼‍🔬", "👨🏼‍✈️", "👨🏽‍🚒"], [#colorLiteral(red: 0.69516927, green: 1, blue: 0.7278235555, alpha: 1)], [#colorLiteral(red: 1, green: 0.7533994317, blue: 0.8303973079, alpha: 1)]],
        "wear" : [["🦺", "👔", "🎩", "⛑", "👜", "🧳", "👠", "👟", "👘", "🥻"], [#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)], [#colorLiteral(red: 0.5044468045, green: 0.7968271375, blue: 0.505887866, alpha: 1)]],
        "animals" : [["🦋", "🐙", "🐞", "🦧", "🐲", "🕷", "🐳", "🦉", "🐆", "🦩"], [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)], [#colorLiteral(red: 0.701218009, green: 0.4075856805, blue: 0.7775961757, alpha: 1)]],
        "wheather" : [["🌈", "🌪", "☀️", "🌧", "🌩", "❄️", "🌬", "⛅️", "🌙", "✨"], [#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)], [#colorLiteral(red: 0.8363432288, green: 0.6690821052, blue: 0.1799195409, alpha: 1)]],
        "food" : [["🍋", "🍉", "🌮", "🍕", "🥞", "🧇", "🥩", "🍖", "🍩", "🍪"], [#colorLiteral(red: 0.5845861435, green: 0.81724298, blue: 0.9657865167, alpha: 1)], [#colorLiteral(red: 0.9824766517, green: 0.7835093737, blue: 0.6774330139, alpha: 1)]]
    ]
    
    var emojis = [Int : String]()
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var flipScoreLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themseOfCurrentGame = getCurrentTheme()
        
        cardButtons.forEach {
            $0.layer.cornerRadius = 8
            $0.backgroundColor = cardColor
        }
        
        self.view.backgroundColor = backGroundColor
        
        newGameButton.layer.cornerRadius = 10
        newGameButton.backgroundColor = cardColor
        newGameButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Dont set card number")
        }
        UIView.transition(with: flipScoreLabel, duration: 0.3, options: .transitionFlipFromBottom, animations: {
            self.flipScoreLabel.text = String(self.game.score)
        }, completion: nil)
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        
        restart()
    }
    
    func updateViewFromModel() {
        
        for index in cardButtons.indices {
            
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = .white
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = (themses[themseOfCurrentGame]!)[1][0] as? UIColor ?? UIColor.white
                
                if card.isMatched {
                    button.backgroundColor = #colorLiteral(red: 0.5476691127, green: 0.5477643609, blue: 0.5476564765, alpha: 0.275803257)
                    button.isEnabled = false
                }
            }
            if game.numberOfMatched == 0 {
                let alert = UIAlertController(title: "🎉CONGRATULATON🎉", message: "\nYou finished the game, You score is: \(game.score)",
                    preferredStyle: .alert)
                let cancle = UIAlertAction(title: "Cancle", style: .destructive)
                let newGame = UIAlertAction(title: "New Game", style: .default, handler: {_ in
                    self.restart()
                })
                alert.addAction(cancle)
                alert.addAction(newGame)
                present(alert, animated: true)
                }
            }
        }
    
    
    func emoji (for card: Card) -> String {
        
        if emojis[card.identifire] == nil, (themses[themseOfCurrentGame]!)[0].count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32((themses[themseOfCurrentGame]!)[0].count)))
            emojis[card.identifire] = ((themses[themseOfCurrentGame]!)[0][randomIndex] as? String ?? "??")
            (themses[themseOfCurrentGame]!)[0].remove(at: randomIndex)
        }
        return emojis[card.identifire] ?? "?"
    }
    
    // get random key for choose current theme
    
    func getCurrentTheme() -> String {
        
        return Array(themses.keys)[Int(arc4random_uniform(UInt32(themses.count)))]
    }
    
    func restart()  {
        
        themseOfCurrentGame = getCurrentTheme()
        game = Concentration(numberOfPairsCards: cardButtons.count/2)
        updateViewFromModel()

        UIView.transition(with: flipScoreLabel, duration: 0.3, options: .transitionFlipFromBottom, animations: {
            self.flipScoreLabel.text = String(self.game.score)
        }, completion: nil)
        
        self.view.backgroundColor = (themses[themseOfCurrentGame]!)[2][0] as? UIColor ?? UIColor.white
        
        newGameButton.backgroundColor = (themses[themseOfCurrentGame]!)[1][0] as? UIColor ?? UIColor.red
        
    }
}

