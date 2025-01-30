import UIKit
import SnapKit

final class SynopsisCollectionViewCell: BaseCollectionViewCell {
    static let id = "SynopsisCollectionViewCell"
    let synopsisLabel = UILabel()

    override func configureHierarchy() {
        contentView.addSubview(synopsisLabel)
    }
    override func configureLayout() {
        synopsisLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    override func configureView() {
        synopsisLabel.text = "테스트용"
        synopsisLabel.numberOfLines = 3
    }
}
