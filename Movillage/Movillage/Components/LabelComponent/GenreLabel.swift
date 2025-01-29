import UIKit

final class GenreLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        font = UIFont.description
        textColor = UIColor.customWhite
        textAlignment = .center
        backgroundColor = UIColor.customGray
        layer.cornerRadius = 6
    }

    // 양 옆 간격 제공
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + 16, height: size.height + 8)
    }
}
