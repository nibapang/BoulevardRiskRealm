//
//  PokerRiskVC.swift
//  BoulevardRiskRealm
//
//  Created by jin fu on 13/02/25.
//

import Foundation
import UIKit

class BoulevardPokerRiskPage: UIViewController {
    
    let cardNames: [String] = {
        let suits = ["clubs", "diamonds", "hearts", "spades"]
        let ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "jack", "queen", "king", "ace"]
        return suits.flatMap { suit in ranks.map { "\($0)_of_\(suit)" } }
    }()
    
    @IBOutlet weak var slot1: UIImageView!
    @IBOutlet weak var slot2: UIImageView!
    @IBOutlet weak var slot3: UIImageView!
    @IBOutlet weak var slot4: UIImageView!
    @IBOutlet weak var slot5: UIImageView!
    @IBOutlet weak var slot6: UIImageView!
    
    @IBOutlet weak var matchedSlot1: UIImageView!
    @IBOutlet weak var matchedSlot2: UIImageView!
    @IBOutlet weak var matchedSlot3: UIImageView!
    @IBOutlet weak var matchedSlot4: UIImageView!
    @IBOutlet weak var matchedSlot5: UIImageView!
    @IBOutlet weak var matchedSlot6: UIImageView!
    
    @IBOutlet weak var userCard: UIImageView!
    
    // The random cards generated for the game
    var generatedCards: [String] = []
    var matchedCardsCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let randomCardSlots = [slot1, slot2, slot3, slot4, slot5, slot6]
        let matchedCardSlots = [matchedSlot1, matchedSlot2, matchedSlot3, matchedSlot4, matchedSlot5, matchedSlot6]
        
        resetMatchedSlots(matchedCardSlots)
        
        setupUserCardTap()
        
        generateRandomCards(for: randomCardSlots)
        
        userCard.image = UIImage(named: "backcard")
        showGameRules()
        
    }
    
    func showGameRules() {
        let rules = """
        **Welcome to DeckMatch Duel! **

        - Six random cards are displayed on the screen.
        - Click on "User Card" to draw a random card.
        - If the drawn card matches one of the displayed cards, it will be highlighted in green.
        - Your goal is to match all six cards.
        - If you match all six cards, then you have the best luck and your lucky moment has come today!

        Good luck!
        """
        
        let alert = UIAlertController(title: "Game Rules", message: rules, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Start Game", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func resetMatchedSlots(_ matchedSlots: [UIImageView?]) {
        for slot in matchedSlots {
            slot?.image = UIImage(named: "backcard")
            slot?.layer.borderWidth = 0
        }
        matchedCardsCount = 0
    }
    
    func setupUserCardTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userCardTapped))
        userCard.addGestureRecognizer(tapGesture)
        userCard.isUserInteractionEnabled = true
    }
    
    func generateRandomCards(for slots: [UIImageView?]) {
        generatedCards = cardNames.shuffled().prefix(6).map { $0 }
        
        for (index, cardName) in generatedCards.enumerated() {
            slots[index]?.image = UIImage(named: cardName)
        }
    }
    
    @objc func userCardTapped() {
        let randomCard = cardNames.randomElement() ?? ""
        
        userCard.image = UIImage(named: randomCard)
        
        if let matchingIndex = generatedCards.firstIndex(of: randomCard) {
            let matchedSlot = [matchedSlot1, matchedSlot2, matchedSlot3, matchedSlot4, matchedSlot5, matchedSlot6][matchingIndex]
            if matchedSlot?.image == UIImage(named: "backcard") {
                matchedSlot?.image = UIImage(named: randomCard)
                 matchedCardsCount += 1
                
                if matchedCardsCount == 6 {
                    showRestartGameAlert()
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.userCard.image = UIImage(named: "backcard")
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.userCard.image = UIImage(named: "backcard")
            }
        }
    }
    
    func showRestartGameAlert() {
        let alert = UIAlertController(title: "Congratulations!", message: "You've matched all cards! your lucky moment has come today!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart Game", style: .default, handler: { _ in
            self.restartGame()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func restartGame() {
        let randomCardSlots = [slot1, slot2, slot3, slot4, slot5, slot6]
        let matchedCardSlots = [matchedSlot1, matchedSlot2, matchedSlot3, matchedSlot4, matchedSlot5, matchedSlot6]
        
        resetMatchedSlots(matchedCardSlots)
        
        generateRandomCards(for: randomCardSlots)
        
        userCard.image = UIImage(named: "backcard")
    }
}
