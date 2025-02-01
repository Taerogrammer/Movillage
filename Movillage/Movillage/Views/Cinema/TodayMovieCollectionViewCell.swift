import UIKit
import Kingfisher
import SnapKit

final class TodayMovieCollectionViewCell: BaseCollectionViewCell {
    static let id = "TodayMovieCollectionViewCell"
    let posterImage = UIImageView()
    let titleLabel = UILabel().setFont(.contentBold)
    let likeButton = UIButton()
    let descriptionLabel = UILabel().setFont(.description)
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
            $0.height.equalTo(16)
        }
        likeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
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
        /// 오늘의 영화 부분에선 indicator가 아닌 백그라운드 색상으로 대기 화면 표시
        /// 어떻게 표시하는 것이 UX적으로 좋은 것인지 잘 모르겠어서 기존의 영화 어플을 참고하였습니다.
        posterImage.backgroundColor = UIColor.customWhiteGray
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
        let url = URL(string: TMDBUrl.imageUrl + "\(item.poster_path)")
        DispatchQueue.main.async {

            /// 오늘의 영화는 하루 단위를 기준으로 업데이트 되기 때문에 하루 동안만 캐시에 저장되도록 지정
            self.posterImage.kf.setImage(with: url, options: [
                .processor(DownsamplingImageProcessor(size: self.posterImage.bounds.size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .memoryCacheExpiration(.days(1)),
                .diskCacheExpiration(.days(1))
                ])
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
