import UIKit

class InvestmentsContainerView: UIScrollView {

    private var investments: [InvestmentView] = []
    private weak var parentViewController: UIViewController?

    init(frame: CGRect, parentViewController: UIViewController) {
        super.init(frame: frame)
        self.parentViewController = parentViewController
        setupInvestments()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInvestments()
    }

    private func setupInvestments() {
        var yOffset: CGFloat = 0
        let invFrameWidth = parentViewController?.view.frame.width ?? 0

        // Assuming you have more than 3 investments
        for _ in 0..<10 {
            let investmentFrame = CGRect(
                x: 0,
                y: yOffset,
                width: invFrameWidth,
                height: invFrameWidth * 360 / 1540
            )
            let farmers = InvestmentView(frame: investmentFrame, spriteName: "FarmerSprite", baseCost: 10, income: 1)

            yOffset += investmentFrame.height

            investments.append(farmers)
            addSubview(farmers)
        }

        // Set the content size of the scroll view based on the total height of investments
        contentSize = CGSize(width: invFrameWidth, height: yOffset)
    }
}
