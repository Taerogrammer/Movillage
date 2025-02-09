import UIKit

final class RoundedButton: UIButton {

    init() {
        super.init(frame: .zero)
        setTitleColor(UIColor.customWhite, for: .normal)
        titleLabel?.font = UIFont.contentBold
        clipsToBounds = true
        layer.cornerRadius = 24
        contentEdgeInsets = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        backgroundColor = UIColor.customBlue
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// isEnabled에 따른 선명도
    override var isEnabled: Bool {
        didSet {
            self.alpha = isEnabled ? 1.0 : 0.5
            self.backgroundColor = isEnabled ? UIColor.customBlue : UIColor.customGray

        }
    }
}
