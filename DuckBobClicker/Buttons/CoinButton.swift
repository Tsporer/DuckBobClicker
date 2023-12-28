//
//  CoinButton.swift
//  DuckBobClicker
//
//  Created by Thomas Sporer on 12/26/23.
//

import Foundation
import UIKit

protocol CoinButtonDelegate: AnyObject {
    func coinButtonPressed()
}

class CoinButton: UIButton {
    
    weak var delegate: CoinButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureButton()
    }

    private func configureButton() {
        let coinButtonImage = UIImage(named: "CopperCoin")
        setImage(coinButtonImage, for: .normal)

        addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])
    }

    @objc private func buttonTouchDown() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.transform = self.transform.scaledBy(x: 0.95, y: 0.95)
        }, completion: nil)
    }

    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.transform = .identity
        }, completion: { _ in
            // Notify the delegate that the button was pressed
            self.delegate?.coinButtonPressed()
        })
    }
}
