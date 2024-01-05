//
//  CoinButton.swift
//  DuckBobClicker
//
//  Created by Thomas Sporer on 12/26/23.
//

import Foundation
import UIKit

protocol CoinButtonDelegate: AnyObject {
    func coinButtonPressed(at point: CGPoint)
}

class CoinButton: UIButton {

    weak var delegate: CoinButtonDelegate?
    weak var coinButtonDelegate: CoinButtonDelegate?
    private var miniCoinImageView: UIImageView?

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

    @objc private func buttonTouchDown(_ sender: UIButton, event: UIEvent) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.transform = self.transform.scaledBy(x: 0.95, y: 0.95)
        }, completion: nil)
        
    }

    @objc private func buttonTouchUp(_ sender: UIButton, event: UIEvent) {
        // Capture the cursor location when the touch begins
        if let touch = event.allTouches?.first {
            let touchLocation = touch.location(in: self)

            // Create the mini coin image view at the captured location
            createMiniCoinImageView(at: touchLocation)

            // Animate the button release
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction], animations: {
                self.transform = .identity
            }, completion: { _ in
                // Notify the delegate that the button was pressed and provide the touch location
                if let center = self.miniCoinImageView?.center {
                    self.delegate?.coinButtonPressed(at: center)
                }

                // Remove the mini coin image view
                self.miniCoinImageView?.removeFromSuperview()
                self.miniCoinImageView = nil
            })
        }
    }

    private func createMiniCoinImageView(at location: CGPoint) {
        let miniCoinImage = UIImage(named: "CopperCoin") // Use the same image for the mini coin
        let miniCoinSize = CGSize(width: bounds.width * 0.5, height: bounds.height * 0.5)
        miniCoinImageView = UIImageView(image: miniCoinImage)
        miniCoinImageView?.frame.size = miniCoinSize
        miniCoinImageView?.center = convert(location, to: superview)
        miniCoinImageView?.isHidden = true
        superview?.addSubview(miniCoinImageView!)
    }
}
