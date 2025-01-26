import UIKit
import SnapKit

final class TodayMovieCollectionViewCell: BaseCollectionViewCell {
    static let id = "TodayMovieCollectionViewCell"
    private let posterImage = UIImageView()
    private let titleLabel = UILabel().setFont(.contentBold)
    private let likeImage = UIImageView()
    private let descriptionLabel = UILabel().setFont(.description)

    override func configureHierarchy() {
        [posterImage, titleLabel, likeImage, descriptionLabel].forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        posterImage.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(titleLabel.snp.top)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImage.snp.bottom).offset(4)
            $0.leading.equalTo(self.safeAreaLayoutGuide)
            $0.trailing.greaterThanOrEqualTo(60)
        }
        likeImage.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        posterImage.clipsToBounds = true
        posterImage.layer.cornerRadius = 8
        posterImage.backgroundColor = .customBlue
        titleLabel.text = "테스트테스트"
        descriptionLabel.text = "설명에 대한 테스틔루미ㅏㄹ"
        descriptionLabel.numberOfLines = 2
        likeImage.image = UIImage(systemName: "heart")
        likeImage.tintColor = UIColor.customBlue
    }
}
