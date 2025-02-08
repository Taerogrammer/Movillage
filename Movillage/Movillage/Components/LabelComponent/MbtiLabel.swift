import UIKit

final class MbtiLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = UIColor.customRed
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        font = UIFont.description
        textColor = UIColor.customWhite
        textAlignment = .center
        backgroundColor = UIColor.customBlack
        layer.cornerRadius = bounds.height / 2
        layer.borderColor = UIColor.customWhiteGray.cgColor
        layer.borderWidth = 2
    }

    func isEnabledOrHighlighted(isHighlighted: Bool) {
        alpha = isHighlighted ? 1.0 : 0.5
        backgroundColor = isHighlighted ? UIColor.customBlue : UIColor.customBlack

    }
}
