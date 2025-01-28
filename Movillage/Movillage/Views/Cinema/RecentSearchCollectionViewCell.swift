import UIKit
import SnapKit

final class RecentSearchCollectionViewCell: BaseCollectionViewCell {
    static let id = "RecentSearchCollectionViewCell"
    let researchLabel = RecentSearchButton()

    override func configureHierarchy() {
        contentView.addSubview(researchLabel)
    }
    override func configureLayout() {
        researchLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    override func configureView() {
        researchLabel.isUserInteractionEnabled = false
    }
}

// MARK: configure cell
extension RecentSearchCollectionViewCell {
    func configureCell(text: String) {
        researchLabel.setTitle(text + " ", for: .normal)
    }
}
