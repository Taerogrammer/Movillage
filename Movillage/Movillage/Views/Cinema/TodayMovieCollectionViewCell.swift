import UIKit
import Kingfisher
import SnapKit

final class TodayMovieCollectionViewCell: BaseCollectionViewCell {
    static let id = "TodayMovieCollectionViewCell"
    let posterImage = UIImageView()
    let titleLabel = UILabel().setFont(.contentBold)
    let likeButton = UIButton()
    let descriptionLabel = UILabel().setFont(.description)

    // TODO: - 위치 수정
    let imageUrl = "https://image.tmdb.org/t/p/original"

    var didLikeButtonTapped: (() -> Void)?

    override func configureHierarchy() {
        [posterImage, titleLabel, likeButton, descriptionLabel].forEach { contentView.addSubview($0) }
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
            $0.trailing.lessThanOrEqualTo(likeButton.snp.leading).inset(8)
            $0.height.equalTo(16)
        }
        likeButton.snp.makeConstraints {
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
        posterImage.backgroundColor = UIColor.customBlue
        descriptionLabel.numberOfLines = 2
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .highlighted)
        likeButton.tintColor = UIColor.customBlue
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
}

// MARK: configure cell
extension TodayMovieCollectionViewCell {
    func configureCell(with item: ResultsResponse) {
        let url = URL(string: imageUrl + "\(item.poster_path)")
        DispatchQueue.main.async {
            self.posterImage.kf.setImage(with: url)
            self.titleLabel.text = item.title
            self.descriptionLabel.text = item.overview
        }
        configureFavorite(by: item.id)
    }
    func configureFavorite(by id: Int) {
        likeButton.isHighlighted = UserDefaultsManager.favoriteMovie.contains(id) ? true : false
    }
}

// MARK: @objc
extension TodayMovieCollectionViewCell {
    @objc private func likeButtonTapped() { didLikeButtonTapped?() }
}
