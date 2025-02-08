import UIKit
import SnapKit

final class MbtiCollectionViewCell: BaseCollectionViewCell {
    static let id = "MbtiCollectionViewCell"
    let mbtiLabel = MbtiLabel()

    override func configureHierarchy() {
        contentView.addSubview(mbtiLabel)
    }
    override func configureLayout() {
        mbtiLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    override func configureView() {
        mbtiLabel.isEnabledOrHighlighted(isHighlighted: false)
    }
}

extension MbtiCollectionViewCell {
    func updateCell(indexPath: IndexPath, selectedIndex: [Int]) {
        let isSelected = selectedIndex.contains(indexPath.item)
        mbtiLabel.isEnabledOrHighlighted(isHighlighted: isSelected)
    }
}
