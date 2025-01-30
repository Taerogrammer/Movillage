import UIKit
import Kingfisher
import SnapKit

final class CastCollectionViewCell: BaseCollectionViewCell {
    static let id = "CastCollectionViewCell"
    let castImage = ProfileImage(frame: CGRect())
    let koreanNameLabel = UILabel().setFont(.contentBold)
    let englishNameLabel = UILabel().setFont(.description)

    override func configureHierarchy() {
        [castImage, koreanNameLabel, englishNameLabel].forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        castImage.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(4)
            $0.width.height.equalTo(44)
            $0.centerY.equalToSuperview()
        }
        koreanNameLabel.snp.makeConstraints {
            $0.leading.equalTo(castImage.snp.trailing).offset(4)
            $0.bottom.equalTo(castImage.snp.centerY).offset(-2)
            $0.trailing.greaterThanOrEqualTo(contentView).inset(12)
        }
        englishNameLabel.snp.makeConstraints {
            $0.leading.equalTo(koreanNameLabel)
            $0.top.equalTo(castImage.snp.centerY).offset(2)
            $0.trailing.lessThanOrEqualTo(contentView).inset(24)
        }
    }
    override func configureView() {
        backgroundColor = UIColor.customBlack
        castImage.backgroundColor = .red
        koreanNameLabel.text = "한글이름"
        koreanNameLabel.textColor = UIColor.customWhite
        englishNameLabel.text = "English Name"
        englishNameLabel.textColor = UIColor.customWhiteGray
    }

}
