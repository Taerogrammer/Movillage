import UIKit
import Kingfisher
import SnapKit

final class BackdropCollectionViewCell: BaseCollectionViewCell {
    static let id = "BackdropCollectionViewCell"
    let backdropImage = UIImageView()
    let pageControl = UIPageControl()

    override func configureHierarchy() {
        [backdropImage, pageControl].forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        backdropImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    override func configureView() {
        backdropImage.backgroundColor = UIColor.customBlack
        backdropImage.contentMode = .scaleAspectFill
        pageControl.currentPage = 0
        pageControl.numberOfPages = 5
    }
}

// MARK: configure cell
extension BackdropCollectionViewCell: ImageCellConfiguration {
    func configureImageCell(with urlString: String?) {
        guard let urlString = urlString else { return }
        guard let url = URL(string: urlString) else { return }
         self.backdropImage.kf.setImage(with: url)
    }
}
