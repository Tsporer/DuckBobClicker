//
//  SkillTree.swift
//  DuckBobClicker
//
//  Created by Thomas Sporer on 12/26/23.
//

import Foundation
import UIKit

class InvestmentsButton: UIButton {
    
    var displayed = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureButton()
    }

    private func configureButton() {
        let investmentsButtonImage = UIImage(named: "InvestmentsZero")
        setImage(investmentsButtonImage, for: .normal)
        addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])
    }

    @objc private func buttonTouchUp() {
        if displayed {
            (self.superview?.next as? GameViewController)?.animateInvestmentsSlideDown()
        } else {
            (self.superview?.next as? GameViewController)?.animateInvestmentsSlideUp()
        }
        displayed = !displayed
    }
}
