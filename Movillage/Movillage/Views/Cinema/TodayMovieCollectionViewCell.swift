import UIKit
import Kingfisher
import SnapKit

final class TodayMovieCollectionViewCell: BaseCollectionViewCell {
    static let id = "TodayMovieCollectionViewCell"
    let posterImage = UIImageView()
    let titleLabel = UILabel().setFont(.contentBold)
    let likeImage = UIImageView()
    let descriptionLabel = UILabel().setFont(.description)

    // TODO: - 위치 수정
    let imageUrl = "https://image.tmdb.org/t/p/original"

    override func configureHierarchy() {
        [posterImage, titleLabel, likeImage, descriptionLabel].forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        posterImage.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalToSuperview().multipliedBy(0.8)
            $0.width.greaterThanOrEqualTo(200)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImage.snp.bottom).offset(4)
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(4)
            $0.trailing.lessThanOrEqualTo(likeImage.snp.leading).inset(8)
        }
        likeImage.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(8)
            $0.width.height.equalTo(16)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(8)
        }
    }
    override func configureView() {
        posterImage.clipsToBounds = true
        posterImage.layer.cornerRadius = 8
        posterImage.backgroundColor = .customBlue
        descriptionLabel.numberOfLines = 2
        likeImage.image = UIImage(systemName: "heart")
        likeImage.tintColor = UIColor.customBlue
    }
}

// MARK: configure cell
extension TodayMovieCollectionViewCell {
    func configureCell(with row: ResultsResponse) {
        titleLabel.text = row.title
        descriptionLabel.text = row.overview
        let url = URL(string: imageUrl + "\(row.poster_path)")
        posterImage.kf.setImage(with: url)
    }
}
