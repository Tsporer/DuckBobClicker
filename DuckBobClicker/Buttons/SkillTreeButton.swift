//
//  SkillTree.swift
//  DuckBobClicker
//
//  Created by Thomas Sporer on 12/26/23.
//

import Foundation
import UIKit

class SkillTreeButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureButton()
    }

    private func configureButton() {
        let skillTreeButtonImage = UIImage(named: "SkillTreeZero")
        setImage(skillTreeButtonImage, for: .normal)

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
