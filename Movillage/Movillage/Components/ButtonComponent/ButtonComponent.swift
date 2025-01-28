import UIKit

final class CustomButton: UIButton {

    init() {
        super.init(frame: .zero)
        setTitleColor(UIColor.customBlue, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 14)
        clipsToBounds = true
        layer.borderWidth = 3
        layer.cornerRadius = 24
        contentEdgeInsets = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        layer.borderColor = UIColor.customBlue.cgColor
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
        }
    }
}
