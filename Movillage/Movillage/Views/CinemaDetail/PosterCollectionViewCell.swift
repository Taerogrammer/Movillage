import UIKit
import Kingfisher
import SnapKit

final class PosterCollectionViewCell: BaseCollectionViewCell {
    static let id = "PosterCollectionViewCell"
    let posterImage = UIImageView()

    override func configureHierarchy() {
        contentView.addSubview(posterImage)
    }
    override func configureLayout() {
        posterImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    override func configureView() {
        posterImage.backgroundColor = .customBlue
    }
}
