import UIKit
import Kingfisher
import SnapKit

final class SearchTableViewCell: BaseTableViewCell {
    static let id = "SearchTableViewCell"
    let posterImage = UIImageView()
    let titleLabel = UILabel().setFont(.contentBold)
    let releaseLabel = UILabel().setFont(.description)
    let genreStackView = UIStackView()
    let likeButton = UIButton()
    var didLikeButtonTapped: (() -> Void)?

    override func configureHierarchy() {
        [posterImage, titleLabel, releaseLabel, genreStackView, likeButton].forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        posterImage.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview().inset(12)
            $0.width.equalTo(88)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(posterImage.snp.trailing).offset(12)
            $0.top.equalTo(posterImage).offset(4)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(12)
        }
        releaseLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        genreStackView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.greaterThanOrEqualTo(releaseLabel.snp.bottom).offset(4)
            $0.trailing.lessThanOrEqualTo(likeButton.snp.leading).offset(-12)
            $0.bottom.equalTo(posterImage)
        }
        likeButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(12)
            $0.width.height.equalTo(32)
            $0.centerY.equalTo(genreStackView)
        }
    }
    override func configureView() {
        posterImage.clipsToBounds = true
        posterImage.layer.cornerRadius = 12
        posterImage.contentMode = .scaleToFill

        titleLabel.numberOfLines = 2

        releaseLabel.textColor = UIColor.customGray

        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage((UIImage(systemName: "heart.fill")), for: .highlighted)
        likeButton.tintColor = UIColor.customBlue
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)

        genreStackView.axis = .horizontal
        genreStackView.spacing = 12
        genreStackView.alignment = .leading
        genreStackView.distribution = .fillProportionally
    }
}

// MARK: configure cell
extension SearchTableViewCell {
    func configureCell(with row: ResultsResponse) {
        if let validUrl = row.poster_path {
            let url = URL(string: TMDBUrl.imageUrl + validUrl)
            posterImage.kf.indicatorType = .activity
            posterImage.kf.setImage(with: url, options: [
                .processor(DownsamplingImageProcessor(size: self.posterImage.bounds.size)),
                .scaleFactor(UIScreen.main.scale)
            ])
        } else {
            posterImage.backgroundColor = UIColor.customGray
        }
        DispatchQueue.main.async {
            self.titleLabel.text = row.title
            self.releaseLabel.text = row.release_date
        }
        configureGenre(genre: row.genre_ids)
        configureFavorite(by: row.id)
    }
    func configureGenre(genre: [Int]) {
        // 셀 재사용 시 다른 장르 들어올 수도 있기 때문에 장르 정보 제거
        genreStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for id in genre {
            let label = GenreLabel()
            label.text = MovieGenre.genreDescription(id: id)
            label.snp.makeConstraints {
                $0.width.greaterThanOrEqualTo(24)
            }
            genreStackView.addArrangedSubview(label)
        }
    }
    func configureFavorite(by id: Int) {
        likeButton.isHighlighted = UserDefaultsManager.favoriteMovie.contains(id) ? true : false
    }
}

// MARK: @objc
extension SearchTableViewCell {
    @objc private func likeButtonTapped() { didLikeButtonTapped?() }
}
