import UIKit
import SnapKit

final class RecentSearchEmptyCell: BaseCollectionViewCell {
    static let id = "RecentSearchEmptyCell"

    private let noRecentSearchLabel = UILabel().setFont(.description)

    override func configureHierarchy() {
        contentView.addSubview(noRecentSearchLabel)
    }
    override func configureLayout() {
        noRecentSearchLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    override func configureView() {
        noRecentSearchLabel.text = "최근 검색어 내역이 없습니다."
        noRecentSearchLabel.textColor = UIColor.customWhiteGray
        noRecentSearchLabel.textAlignment = .center
    }
}
