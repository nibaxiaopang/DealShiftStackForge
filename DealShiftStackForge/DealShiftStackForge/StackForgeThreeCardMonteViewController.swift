//
//  ThreeCardMonteVC.swift
//  DealShiftStackForge
//
//  Created by jin fu on 2024/11/14.
//

import UIKit

class StackForgeThreeCardMonteViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var winGifImage: UIImageView!
    
    // MARK: - Properties
    private var winningCardIndex = Int.random(in: 0..<3)
    private let cardBackImage = UIImage(named: "cardBack") // Card back image
    private let cardAceImage = UIImage(named: "cardAce") // Ace card image
    private let cardJokerImage = UIImage(named: "cardJoker") // Joker card image
    
    private var shuffleTimer: Timer? // Timer for repeated shuffle
    private var shuffleCount = 0 // Counter for shuffle cycles
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        playAgainButton.isHidden = true // Hide play again initially
        startGame()
        winGifImage.isHidden = true
        winGifImage.image = UIImage.gifImageWithName("Win")
    }
    
    // MARK: - Game Setup
    func startGame() {
        winGifImage.isHidden = true
        resultLabel.text = "Watch carefully!"
        winningCardIndex = Int.random(in: 0..<3)
        
        // Show all cards briefly: 1 Ace and 2 Jokers
        for (index, button) in cardButtons.enumerated() {
            if index == winningCardIndex {
                button.setImage(cardAceImage, for: .normal)
            } else {
                button.setImage(cardJokerImage, for: .normal)
            }
            button.isEnabled = false // Disable taps initially
        }
        
        // Hide cards after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.hideCards()
        }
    }
    
    func hideCards() {
        // Show back images on all cards
        for button in cardButtons {
            button.setImage(self.cardBackImage, for: .normal)
        }
        
        // Start shuffling cards at 0.5-second intervals for 5 seconds
        shuffleCount = 0
        shuffleTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(performShuffle), userInfo: nil, repeats: true)
    }
    
    @objc func performShuffle() {
        // Perform a shuffle animation by swapping two random cards
        let firstIndex = Int.random(in: 0..<3)
        var secondIndex = Int.random(in: 0..<3)
        while secondIndex == firstIndex {
            secondIndex = Int.random(in: 0..<3)
        }
        
        UIView.animate(withDuration: 1.0) {
            self.swapCards(at: firstIndex, with: secondIndex)
        }
        
        // Increment the shuffle count
        shuffleCount += 1
        
        // Stop shuffling after 5 seconds (10 shuffles at 0.5-second intervals)
        if shuffleCount >= 10 {
            shuffleTimer?.invalidate()
            shuffleTimer = nil
            promptUserForGuess()
        }
    }
    
    func swapCards(at firstIndex: Int, with secondIndex: Int) {
        // Swap the positions of two cards with animation
        let firstButton = cardButtons[firstIndex]
        let secondButton = cardButtons[secondIndex]
        
        UIView.animate(withDuration: 1.0) {
            let tempFrame = firstButton.frame
            firstButton.frame = secondButton.frame
            secondButton.frame = tempFrame
        }
    }
    
    func promptUserForGuess() {
        resultLabel.text = "Where's the Ace? Tap a card to guess!"
        
        // Enable card taps
        for button in cardButtons {
            button.isEnabled = true
        }
    }
    
    // MARK: - Actions
    @IBAction func cardTapped(_ sender: UIButton) {
        guard let index = cardButtons.firstIndex(of: sender) else { return }
        
        // Reveal chosen card
        revealCard(at: index)
        
        // Disable further taps
        for button in cardButtons {
            button.isEnabled = false
        }
        
        // Show result
        if index == winningCardIndex {
            resultLabel.text = "You found the Ace! 🎉"
            winGifImage.isHidden = false
        } else {
            resultLabel.text = "Wrong guess! Try again."
        }
        
        // Show "Play Again" button
        playAgainButton.isHidden = false
    }
    
    func revealCard(at index: Int) {
        let cardButton = cardButtons[index]
        if index == winningCardIndex {
            cardButton.setImage(cardAceImage, for: .normal)
        } else {
            cardButton.setImage(cardJokerImage, for: .normal)
        }
    }
    
    @IBAction func playAgainTapped(_ sender: UIButton) {
        playAgainButton.isHidden = true
        startGame()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


