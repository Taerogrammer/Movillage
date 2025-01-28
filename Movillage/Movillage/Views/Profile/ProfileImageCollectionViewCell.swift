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
        imageView.backgroundColor = UIColor.customBlack
        imageView.didImageSelected(isHighlighted: false)
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                imageView.didImageSelected(isHighlighted: true)
            } else {
                imageView.didImageSelected(isHighlighted: false)
            }
        }
    }
}

// MARK: configure cell
extension ProfileImageCollectionViewCell {
    func configureCell(index: String, isSelected: Bool) {
        imageView.image = UIImage(named: index)
        imageView.didImageSelected(isHighlighted: isSelected)
    }
}
