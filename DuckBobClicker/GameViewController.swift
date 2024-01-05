//
//  GameViewController.swift
//  DuckBobClicker
//
//  Created by Thomas Sporer on 12/26/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, CoinButtonDelegate {
    
    
    // Main Components
    var coinButton: CoinButton!
    var skillTreeButton: SkillTreeButton!
    var investmentsButton: InvestmentsButton!
    var scoreLabel: UILabel!
    var frames: UIImageView!
    var flippedFrames: UIImageView!
    var score = 0 {
        didSet {
            // Save the score whenever it changes
            UserDefaults.standard.set(score, forKey: "score")
        }
    }
    
    var coinButtonDelegate: CoinButtonDelegate?
    
    // Investments
    var investmentsContainer: InvestmentsContainerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the score from UserDefaults
        score = UserDefaults.standard.integer(forKey: "score")
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                    
                    // Add frames
//                    frames = UIImageView()
                    setupFrames()
                    view.addSubview(frames)
                    setupTopFrames()
                    
                    // Add a Score Label
                    scoreLabel = UILabel()
                    setupScoreLabel()
                    view.addSubview(scoreLabel)
                    
                    // Add a CoinButton
                    coinButton = CoinButton(type: .custom)
                    coinButton.delegate = self
                    coinButton.coinButtonDelegate = self  // Assign the delegate for smaller coin animation
                    setupCoinButton()
                    view.addSubview(coinButton)
                    
                    // Add a SkillTree Button
                    skillTreeButton = SkillTreeButton(type: .custom)
                    setupSkillTreeButton()
                    view.addSubview(skillTreeButton)
                    
                    // Add an Investments Button
                    investmentsButton = InvestmentsButton(type: .custom)
                    setupInvestmentsButton()
                    investmentsButton.layer.zPosition = 1
                    view.addSubview(investmentsButton)
                    
                    // Investments
                    
                    // Add farmers
                    let containerWidth = view.frame.width
                    let containerHeight: CGFloat = 500 // Adjust the height as needed
                    let containerX: CGFloat = 0
                    let containerY = view.frame.height + containerHeight // Start off-screen below the view
                    investmentsContainer = InvestmentsContainerView(frame: CGRect(
                        x: containerX,
                        y: containerY,
                        width: containerWidth,
                        height: containerHeight
                    ), parentViewController: self)
                    setupInvestmentsContainer()
                    view.addSubview(investmentsContainer)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Save the score to UserDefaults when the view is about to disappear
        UserDefaults.standard.set(score, forKey: "score")
    }
    
    private func setupFrames() {
        let framesImage = UIImage(named: "FrameZero")
        frames = UIImageView(image: framesImage)
        let frameWidth = (view.frame.width)
        let frameHeight = (view.frame.height) / 16
        let frameX: CGFloat = 0
        let frameY_top = (view.frame.height) - (frameHeight)
        frames.frame = CGRect(
            x: frameX,
            y: frameY_top,
            width: frameWidth,
            height: frameHeight
        )
    }
    
    private func setupTopFrames() {
        let framesImage = UIImage(named: "FrameZero")
        flippedFrames = UIImageView(image: framesImage)
        let frameWidth = view.frame.width
        let frameHeight = (view.frame.height) / 16
        let frameX: CGFloat = 0
        let frameY_top = view.safeAreaInsets.top
        flippedFrames.frame = CGRect(
            x: frameX,
            y: frameY_top,
            width: frameWidth,
            height: frameHeight
        )

        flippedFrames.transform = CGAffineTransform(scaleX: 1, y: -1) // Flip vertically
        view.addSubview(flippedFrames)
    }
    
    private func setupScoreLabel() {
        scoreLabel.text = "\(score)"
        scoreLabel.font = UIFont(name: "Silkscreen-Regular", size: 46)
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .center
        scoreLabel.frame = CGRect(x: 0, y: 75, width: view.frame.width, height: 46)
    }
    
    private func setupCoinButton() {
        let buttonWidth: CGFloat = 250
        let buttonHeight: CGFloat = 250
        let buttonX = (view.frame.width - buttonWidth) / 2
        let buttonY: CGFloat = 150
        coinButton.frame = CGRect(
            x: buttonX,
            y: buttonY,
            width: buttonWidth,
            height: buttonHeight
        )
    }
    
    private func setupSkillTreeButton() {
        let frameHeight = (view.frame.height) / 16
        let stButtonWidth: CGFloat = (view.frame.width) / 2
        let stButtonHeight = stButtonWidth * 360 / 770
        let stButtonX = (view.frame.width) - stButtonWidth
        let stButtonY = (view.frame.height) - stButtonHeight - frameHeight
        skillTreeButton.frame = CGRect(
            x: stButtonX,
            y: stButtonY,
            width: stButtonWidth,
            height: stButtonHeight
        )
    }
    
    private func setupInvestmentsButton() {
        let frameHeight = (view.frame.height) / 16
        let iButtonWidth: CGFloat = (view.frame.width) / 2
        let iButtonHeight = iButtonWidth * 360 / 770
        let iButtonX = (view.frame.width) - (iButtonWidth * 2)
        let iButtonY = (view.frame.height) - iButtonHeight - frameHeight
        investmentsButton.frame = CGRect(
            x: iButtonX,
            y: iButtonY,
            width: iButtonWidth,
            height: iButtonHeight
        )
    }
    
    func coinButtonPressed(at point: CGPoint) {
        // Increment the score and update the label
        score += 1
        scoreLabel.text = "\(score)"
        
        // Notify the CoinButtonDelegate to handle the smaller coin animation
        coinButtonDelegate?.coinButtonPressed(at: point)
        
        // Create a smaller coin view
        let smallCoinSize: CGFloat = 30
        let smallCoinView = UIImageView(frame: CGRect(x: point.x - smallCoinSize/2, y: point.y - smallCoinSize/2, width: smallCoinSize, height: smallCoinSize))
        smallCoinView.image = UIImage(named: "CopperCoin") // Use the appropriate image name
        view.addSubview(smallCoinView)

        // Animate the smaller coin
        UIView.animate(withDuration: 1.0, animations: {
            smallCoinView.center.y -= 100 // Adjust the distance the smaller coin will move up
            smallCoinView.alpha = 0.0
        }, completion: { _ in
            // Remove the smaller coin view after the animation is complete
            smallCoinView.removeFromSuperview()
        })
    }
    
    private func setupInvestmentsContainer() {
        let containerWidth = view.frame.width
        let containerHeight: CGFloat = view.frame.width * 360 / 1540 * 3 // Adjust the height as needed
        let containerX: CGFloat = 0
        let containerY = view.frame.height + containerHeight // Start off-screen below the view
        investmentsContainer.frame = CGRect(
            x: containerX,
            y: containerY,
            width: containerWidth,
            height: containerHeight
        )
        investmentsContainer.layer.zPosition = -1  // Set a value higher than buttons' zPosition
    }
    
    public func animateInvestmentsSlideUp() {
        // Necessary dimensions
        let frameHeight = (view.frame.height) / 16
        let stButtonWidth: CGFloat = (view.frame.width) / 2
        let stButtonHeight = stButtonWidth * 360 / 770

        let targetY = self.view.frame.height - (self.investmentsContainer.frame.height) - frameHeight - stButtonHeight
        

        UIView.animate(withDuration: 0.5) {
            // Update the constraints or frame size to slide it up
            self.investmentsContainer.frame.origin.y = targetY
        }
    }

    public func animateInvestmentsSlideDown() {
        let targetY = self.view.frame.height

        UIView.animate(withDuration: 0.5) {
            // Update the constraints or frame size to slide it down
            self.investmentsContainer.frame.origin.y = targetY
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
