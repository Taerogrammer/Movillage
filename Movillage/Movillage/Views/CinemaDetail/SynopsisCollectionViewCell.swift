import UIKit
import SnapKit

final class SynopsisCollectionViewCell: BaseCollectionViewCell {
    static let id = "SynopsisCollectionViewCell"
    let synopsisLabel = UILabel().setFont(.description)

    override func configureHierarchy() {
        contentView.addSubview(synopsisLabel)
    }
    override func configureLayout() {
        synopsisLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
    }
    override func configureView() {
        synopsisLabel.text = "줄거리 정보가 존재하지 않습니다"
        synopsisLabel.numberOfLines = 3
    }
}

extension SynopsisCollectionViewCell {
    func configureCell(with data: String) {
        synopsisLabel.text = (data == "") ? "줄거리 정보가 존재하지 않습니다" : data
    }
}
