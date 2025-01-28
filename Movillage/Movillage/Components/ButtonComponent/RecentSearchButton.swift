import UIKit

final class RecentSearchButton: UIButton {

    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.customWhite
        setTitleColor(UIColor.customBlack, for: .normal)
        titleLabel?.font = UIFont.description
        setImage(UIImage(systemName: "xmark"), for: .normal)
        tintColor = UIColor.customBlack
        clipsToBounds = true
        layer.cornerRadius = 20
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        semanticContentAttribute = .forceRightToLeft
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
