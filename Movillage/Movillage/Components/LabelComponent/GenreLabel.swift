import UIKit

final class GenreLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clipsToBounds = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        font = UIFont.description
        textColor = UIColor.customWhite
        backgroundColor = UIColor.customGray
        layer.cornerRadius = 6
    }

    // 양 옆 간격 제공
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + 8, height: size.height + 4)
    }
}
