//
//  InvestmentView.swift
//  DuckBobClicker
//
//  Created by Thomas Sporer on 12/27/23.
//

import Foundation
import UIKit

class InvestmentView: UIButton {
    
    private var incomeStarted = false

    var amount: Int = 0
    var baseCost: Int = 0
    var income: Int = 0

    // Callback for handling the purchase
    var purchaseHandler: (() -> Void)?
    var updateScoreHandler: ((Int) -> Void)?
//    var updateScoreHandler: ((Double) -> Void)?
    
    // Image view for the investment sprite
    private let farmersImageView = UIImageView()
    
    // Labels for displaying cost, income, and amount
    private let costLabel = UILabel()
    private let incomeLabel = UILabel()
    private let amountLabel = UILabel()
    
    weak var parentViewController: GameViewController?

    init(frame: CGRect, spriteName: String, baseCost: Int, income: Int) {
        super.init(frame: frame)
        self.baseCost = baseCost
        self.income = income
        configureButton(spriteName: spriteName)
        updateUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureButton(spriteName: "")
    }

    private func configureButton(spriteName: String) {
        let backdropImage = UIImage(named: "InvestmentBackdropZero")
        setImage(backdropImage, for: .normal)

        farmersImageView.image = UIImage(named: spriteName)
        farmersImageView.contentMode = .scaleAspectFit
        farmersImageView.isUserInteractionEnabled = false // Allow interactions to pass through the image view

        // Add the image view as a subview to the button
        addSubview(farmersImageView)

        farmersImageView.translatesAutoresizingMaskIntoConstraints = false
        farmersImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        farmersImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -UIScreen.main.bounds.width * 0.375).isActive = true
        farmersImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        farmersImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
        farmersImageView.layer.zPosition = 1
        costLabel.layer.zPosition = 2
        incomeLabel.layer.zPosition = 2
        amountLabel.layer.zPosition = 2

        addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])

        // Add labels to display cost, income, and amount
        setupLabels()
    }

    private func setupLabels() {
        // Cost Label
        costLabel.text = "\(cost)"
        costLabel.textAlignment = .center
        costLabel.textColor = .white
        costLabel.translatesAutoresizingMaskIntoConstraints = false
        costLabel.font = UIFont(name: "Silkscreen-Regular", size: 24)
        addSubview(costLabel)

        // Income Label
        incomeLabel.text = "\(totalIncome) / sec"
        incomeLabel.textAlignment = .center
        incomeLabel.textColor = .white
        incomeLabel.translatesAutoresizingMaskIntoConstraints = false
        incomeLabel.font = UIFont(name: "Silkscreen-Regular", size: 24)
        addSubview(incomeLabel)

        // Amount Label
        amountLabel.text = "\(amount)"
        amountLabel.textAlignment = .center
        amountLabel.textColor = .white
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.font = UIFont(name: "Silkscreen-Regular", size: 20)
        addSubview(amountLabel)

        // Add constraints for label positioning within the button
        costLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        costLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20).isActive = true

        incomeLabel.centerXAnchor.constraint(equalTo: leadingAnchor, constant: UIScreen.main.bounds.width * 0.60).isActive = true
        incomeLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 20).isActive = true

        amountLabel.centerXAnchor.constraint(equalTo: leadingAnchor, constant: UIScreen.main.bounds.width * 0.275).isActive = true
        amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 20).isActive = true
    }

    private func updateUI() {
        // Update labels with current values
        costLabel.text = "\(cost)"
        incomeLabel.text = "\(totalIncome) / sec"
        amountLabel.text = "x\(amount)"
    }

    private var cost: Int {
        // Exponential increase in cost based on the initial cost
        let result = baseCost * Int(pow(1.5, Double(amount)))
        return result
    }

    private var totalIncome: Int {
        return income * amount
    }

    @objc private func buttonTouchDown() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.alpha = 0.7
        }, completion: nil)
    }

    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.alpha = 1
        }, completion: nil)

        // Execute the purchaseHandler when the button is tapped
        purchaseHandler?()
    }

    // Function to handle the purchase
    func purchase() {
        // Check if the player has enough score to make the purchase
        let purchaseCost = cost
        guard parentViewController?.score ?? 0 >= purchaseCost else {
            // Handle the case when the player doesn't have enough score
            print("Not enough score to make the purchase")
            return
        }

        // Deduct the cost from the score
        parentViewController?.score -= purchaseCost
        parentViewController?.scoreLabel.text = "\(parentViewController?.score ?? 0)"

        // Implement your purchase logic here
        // For example, increase the amount, start earning income, and update the UI
        amount += 1

        // Notify GameViewController about the income generated
        updateScoreHandler?(totalIncome)
        
        if !incomeStarted {
            startIncome()
            incomeStarted = true
        }

        // Update UI as needed
        updateUI()
    }
    
    // Function to start earning income
    private func startIncome() {
        // You can use a Timer to periodically add income to the score
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            // Notify GameViewController about the income generated
            self.updateScoreHandler?(self.totalIncome)
        }
    }
}

