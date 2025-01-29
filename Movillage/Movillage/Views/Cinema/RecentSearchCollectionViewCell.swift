import UIKit
import SnapKit

final class RecentSearchCollectionViewCell: BaseCollectionViewCell {
    static let id = "RecentSearchCollectionViewCell"
    let researchLabel = UILabel().setFont(.description)
    let xButton = UIButton()

    override func configureHierarchy() {
        [researchLabel, xButton].forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        researchLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.verticalEdges.equalToSuperview().inset(8)
        }
        xButton.snp.makeConstraints {
            $0.leading.equalTo(researchLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(researchLabel)
        }
    }
    override func configureView() {
        researchLabel.textColor = UIColor.customBlack
        clipsToBounds = true
        layer.cornerRadius = 20
        xButton.isUserInteractionEnabled = false
        xButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        xButton.tintColor = UIColor.customBlack
        backgroundColor = UIColor.customWhite
    }
}

// MARK: configure cell
extension RecentSearchCollectionViewCell {
    func configureCell(text: String) { researchLabel.text = text }
}
