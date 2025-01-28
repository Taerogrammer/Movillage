import UIKit
import SnapKit

final class ProfileImageCollectionViewCell: BaseCollectionViewCell {
    static let id = "ProfileImageCollectionViewCell"
    private let imageView = UIImageView()

    override func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    override func configureLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
    override func configureView() {
        imageView.backgroundColor = .red
    }
}
