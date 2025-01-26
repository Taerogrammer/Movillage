import UIKit
import SnapKit

final class RecentSearchCollectionViewCell: BaseCollectionViewCell {
    static let id = "RecentSearchCollectionViewCell"
    private let testLabel = UILabel()

    override func configureHierarchy() {
        contentView.addSubview(testLabel)
    }
    override func configureLayout() {
        testLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    override func configureView() {
        testLabel.text = "스파이더맨"
    }
}
