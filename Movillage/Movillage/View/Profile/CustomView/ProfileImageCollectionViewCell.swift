import UIKit
import SnapKit

final class ProfileImageCollectionViewCell: BaseCollectionViewCell {
    static let id = "ProfileImageCollectionViewCell"
    private let imageView = ProfileImage(frame: CGRect())

    override func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    override func configureLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
    override func configureView() {
        imageView.isEnabledOrHighlighted(isHighlighted: false)
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                imageView.isEnabledOrHighlighted(isHighlighted: true)
            } else {
                imageView.isEnabledOrHighlighted(isHighlighted: false)
            }
        }
    }
}

// MARK: configure cell
extension ProfileImageCollectionViewCell {
    func configureCell(index: String, isSelected: Bool) {
        imageView.image = UIImage(named: index)
        imageView.isEnabledOrHighlighted(isHighlighted: isSelected)
    }
}
