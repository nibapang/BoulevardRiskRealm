//
//  DiceVC.swift
//  BoulevardRiskRealm
//
//  Created by jin fu on 13/02/25.
//

import Foundation
import UIKit

class BoulevardDicePage: UIViewController {

    // Outlets for 6 UIImageViews
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var imageView6: UIImageView!

    @IBOutlet weak var DiceImage: UIImageView!
    // Outlet for total label
    @IBOutlet weak var totalLabel: UILabel!

    // Outlet for spin button
    @IBOutlet weak var spinButton: UIButton!

    // Variable to track the current dice value and game state
    var diceValues: [Int] = []
    var currentTotal = 0
    var requiredTotal = 28
    var remainingChances = 6

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetGame()
    }

    func resetGame() {
        // Reset the game state
        currentTotal = 0
        remainingChances = 6
        requiredTotal = Int.random(in: 15...20)
        diceValues = []
        totalLabel.text = "Target: \(requiredTotal), Remaining: \(remainingChances)"

        // Reset image views
        let placeholderImage = UIImage(named: "backcard")
        imageView1.image = placeholderImage
        imageView2.image = placeholderImage
        imageView3.image = placeholderImage
        imageView4.image = placeholderImage
        imageView5.image = placeholderImage
        imageView6.image = placeholderImage
    }

    @IBAction func spinDice(_ sender: UIButton) {
        guard remainingChances > 0 else {
            showAlert(title: "Game Over", message: "No more chances left. Try again!")
            return
        }

        // Generate a random dice value
        let diceValue = Int.random(in: 1...6)

        // Check if adding the dice value exceeds the target total
        if currentTotal + diceValue > requiredTotal {
            viewAlert(title: "Invalid Move", message: "The dice value \(diceValue) exceeds the target total. Try again!")
            return
        }
        
        func viewAlert(title : String ,message : String){
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
             self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss(animated: true)
            }
        }

        diceValues.append(diceValue)
        currentTotal += diceValue
        remainingChances -= 1
        DiceImage.image = UIImage(named: "dice\(diceValue)")

        // Update the corresponding image view
        let diceImage = UIImage(named: "\(diceValue)")
        switch diceValues.count {
        case 1: imageView1.image = diceImage
        case 2: imageView2.image = diceImage
        case 3: imageView3.image = diceImage
        case 4: imageView4.image = diceImage
        case 5: imageView5.image = diceImage
        case 6: imageView6.image = diceImage
        default: break
        }

        // Update the total label
        totalLabel.text = "Target: \(requiredTotal), Current: \(currentTotal), Remaining: \(remainingChances)"

        // Check game status
        if currentTotal == requiredTotal {
            showAlert(title: "You Win!", message: "You matched the target total \(requiredTotal) in \(6 - remainingChances) chances!")
        } else if remainingChances == 0 && currentTotal != requiredTotal {
            showAlert(title: "You Lose!", message: "You couldn’t match the target total \(requiredTotal). Try again!")
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.resetGame()
        }))
        present(alert, animated: true, completion: nil)
    }
}
