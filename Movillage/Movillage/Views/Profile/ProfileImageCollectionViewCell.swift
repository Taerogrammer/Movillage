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
    }
}

// MARK: configure cell
extension ProfileImageCollectionViewCell {
    func configureCell(index: String) {
        imageView.image = UIImage(named: index)
    }
}
