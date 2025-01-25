import UIKit

final class ProfileImage: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = true
    }
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        clipsToBounds = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        layer.borderWidth = 3
        layer.borderColor = UIColor.customBlue.cgColor
    }
}
