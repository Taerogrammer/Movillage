import UIKit
import SnapKit
import Kingfisher

final class SearchTableViewCell: BaseTableViewCell {
    static let id = "SearchTableViewCell"
    let posterImage = UIImageView()
    let titleLabel = UILabel().setFont(.contentBold)
    let releaseLabel = UILabel().setFont(.description)
    let genreStackView = UIStackView()

    //TODO: likeImage 중 결정하기
    let likeButton = UIButton()

    // TODO: - 위치 수정
    let imageUrl = "https://image.tmdb.org/t/p/original"

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
        releaseLabel.textColor = UIColor.customGray
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = UIColor.customBlue
    }
}

extension SearchTableViewCell {
    func configureCell(with row: ResultsResponse) {
        let url = URL(string: imageUrl + row.poster_path)
        DispatchQueue.main.async {
            self.posterImage.kf.setImage(with: url)
            self.titleLabel.text = row.title
            self.releaseLabel.text = row.release_date
        }
    }
}
