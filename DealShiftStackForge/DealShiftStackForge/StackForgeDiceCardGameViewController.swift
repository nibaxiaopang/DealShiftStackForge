//
//  DiceAndCardGameVC.swift
//  DealShiftStackForge
//
//  Created by jin fu on 2024/11/14.
//

import UIKit

class StackForgeDiceCardGameViewController: UIViewController {
    
    @IBOutlet weak var cardAButton: UIButton!
    @IBOutlet weak var card2Button: UIButton!
    @IBOutlet weak var card3Button: UIButton!
    @IBOutlet weak var card4Button: UIButton!
    @IBOutlet weak var card5Button: UIButton!
    @IBOutlet weak var card6Button: UIButton!
    @IBOutlet weak var card7Button: UIButton!
    @IBOutlet weak var card8Button: UIButton!
    @IBOutlet weak var card9Button: UIButton!
    @IBOutlet weak var card10Button: UIButton!
    @IBOutlet weak var cardJButton: UIButton!
    @IBOutlet weak var cardQButton: UIButton!
    
    @IBOutlet weak var dice1ImageView: UIImageView!
    @IBOutlet weak var dice2ImageView: UIImageView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var rollDiceButton: UIButton!
    @IBOutlet weak var resetGameButton: UIButton!

    var diceTotal: Int = 0
    var validCardValues: Set<Int> = []
    var selectedCards: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardButtons()
        submitButton.isEnabled = false
    }
    
    func setupCardButtons() {
        let cardImages = ["A♦️", "2♦️", "3♦️", "4♦️", "5♦️", "6♦️", "7♦️", "8♦️", "9♦️", "10♦️", "J♦️", "Q♦️"]

        
        for (index, button) in [cardAButton, card2Button, card3Button, card4Button, card5Button,
                                card6Button, card7Button, card8Button, card9Button, card10Button,
                                cardJButton, cardQButton].enumerated() {
            button?.setImage(UIImage(named: cardImages[index]), for: .normal)
            button?.tag = index + 1
        }
    }
    
    func rollDice() {
        let dice1 = Int.random(in: 1...6)
        let dice2 = Int.random(in: 1...6)
        
        dice1ImageView.image = UIImage(named: "dice\(dice1)")
        dice2ImageView.image = UIImage(named: "dice\(dice2)")
        
        diceTotal = dice1 + dice2
        print("Dice total: \(diceTotal)")
        determineValidCardValues()
    }
    
    func determineValidCardValues() {
        validCardValues.removeAll()
        if diceTotal <= 12 {
            validCardValues.insert(diceTotal)
        }
        if diceTotal > 2 {
            for i in 1...min(12, diceTotal - 1) {
                let j = diceTotal - i
                if j >= 1 && j <= 12 {
                    validCardValues.insert(i)
                    validCardValues.insert(j)
                }
            }
        }
        print("Valid card values: \(validCardValues)")
    }
    
    @IBAction func cardTapped(_ sender: UIButton) {
        let cardValue = sender.tag
        if validCardValues.contains(cardValue) {
            selectedCards.append(sender)
            flipCard(sender)
        } else {
            print("Tapped card with tag \(cardValue) is not valid for dice total \(diceTotal)")
        }
    }
    
    func flipCard(_ sender: UIButton) {
        sender.setImage(UIImage(named: "flipped\(sender.tag)"), for: .normal)
    }
    
    func disableCard(_ sender: UIButton) {
        sender.isEnabled = false
        sender.setImage(UIImage(named: "CardBackSide"), for: .normal)
    }
    
    @IBAction func rollDiceButtonTapped(_ sender: UIButton) {
        rollDice()
        submitButton.isEnabled = true
        rollDiceButton.isEnabled = false
        selectedCards.removeAll()
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        let selectedSum = selectedCards.reduce(0) { $0 + $1.tag }
        
        if selectedSum == diceTotal {
            for card in selectedCards {
                disableCard(card)
            }
            selectedCards.removeAll()
            print("Combination matches! Total: \(selectedSum)")
            submitButton.isEnabled = false
            rollDiceButton.isEnabled = true
        } else {
            showAlertForMismatch(selectedSum: selectedSum)
        }
    }

    func resetGame() {
        dice1ImageView.image = nil
        dice2ImageView.image = nil
        
        diceTotal = 0
        
        validCardValues.removeAll()
        selectedCards.removeAll()
        
        let cardButtons = [cardAButton, card2Button, card3Button, card4Button, card5Button,
                           card6Button, card7Button, card8Button, card9Button, card10Button,
                           cardJButton, cardQButton]
        
        for button in cardButtons {
            button?.isEnabled = true
            button?.setImage(UIImage(named: "CardBackSide"), for: .normal)
        }
        
        submitButton.isEnabled = false
        rollDiceButton.isEnabled = true
    }

    func showAlertForMismatch(selectedSum: Int) {
        let alert = UIAlertController(
            title: "Mismatch",
            message: "Selected cards total \(selectedSum) does not match dice total \(diceTotal).",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Reset the images of selected cards back to their front image (unflipped state)
            for card in self.selectedCards {
                if let cardImage = UIImage(named: "\(card.tag)♦️") {
                    card.setImage(cardImage, for: .normal)
                }
            }
            // Clear selected cards after showing the alert
            self.selectedCards.removeAll()
        }))
        
        present(alert, animated: true, completion: nil)
    }

    
    @IBAction func resetGameButtonTapped(_ sender: UIButton) {
        resetGame()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
