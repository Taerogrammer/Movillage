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
        posterImage.contentMode = .scaleAspectFit
    }
}

// MARK: configure cell
extension PosterCollectionViewCell: ImageCellConfiguration {
    func configureImageCell(with urlString: String?) {
        guard let urlString = urlString else { return }
        guard let url = URL(string: urlString) else { return }
        posterImage.kf.indicatorType = .activity
        posterImage.kf.setImage(with: url, options: [
            .processor(DownsamplingImageProcessor(size: posterImage.bounds.size)),
            .scaleFactor(UIScreen.main.scale)
        ])
    }
}
