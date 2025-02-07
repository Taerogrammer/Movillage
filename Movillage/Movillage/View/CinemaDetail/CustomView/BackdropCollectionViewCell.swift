import UIKit
import Kingfisher
import SnapKit

final class BackdropCollectionViewCell: BaseCollectionViewCell {
    static let id = "BackdropCollectionViewCell"
    
    let backdropImage = UIImageView()

    override func configureHierarchy() {
        [backdropImage].forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        backdropImage.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        backdropImage.contentMode = .scaleAspectFill
    }
}

// MARK: configure cell
extension BackdropCollectionViewCell: ImageCellConfiguration {
    func configureImageCell(with urlString: String?) {
        guard let urlString = urlString else { return }
        guard let url = URL(string: urlString) else { return }
        backdropImage.kf.indicatorType = .activity
        backdropImage.kf.setImage(with: url, options: [
            .processor(DownsamplingImageProcessor(size: self.backdropImage.bounds.size)),
            .scaleFactor(UIScreen.main.scale)
        ])
    }
}
