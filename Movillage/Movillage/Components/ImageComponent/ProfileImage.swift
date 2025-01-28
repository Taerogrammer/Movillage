import UIKit

final class ProfileImage: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = true
        backgroundColor = UIColor.customBlack
    }
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    func isEnabledOrHighlighted(isHighlighted: Bool) {
        layer.borderWidth = isHighlighted ? 3 : 1
        layer.borderColor = isHighlighted ? UIColor.customBlue.cgColor : UIColor.customGray.cgColor
        alpha = isHighlighted ? 1.0 : 0.5
    }
}
