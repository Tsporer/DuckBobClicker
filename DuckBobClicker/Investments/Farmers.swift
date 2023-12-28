//
//  SkillTree.swift
//  DuckBobClicker
//
//  Created by Thomas Sporer on 12/26/23.
//

import Foundation
import UIKit

class Farmers: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureButton()
    }

    private func configureButton() {
        let backdropImage = UIImage(named: "InvestmentBackdropZero")
        setImage(backdropImage, for: .normal)
        // Create an image view for the farmersImage
        let farmersImageView = UIImageView(image: UIImage(named: "FarmerSprite"))
        farmersImageView.contentMode = .scaleAspectFit
        farmersImageView.isUserInteractionEnabled = false // Allow interactions to pass through the image view

        // Add the image view as a subview to the button
        addSubview(farmersImageView)

        farmersImageView.translatesAutoresizingMaskIntoConstraints = false
        farmersImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        farmersImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -UIScreen.main.bounds.width * 0.375).isActive = true
        farmersImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        farmersImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true

        addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])
    }

    @objc private func buttonTouchDown() {
        print("Hi!")
    }

    @objc private func buttonTouchUp() {
       print("Hi!")
    }
}
