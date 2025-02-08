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
    override var isSelected: Bool {
        didSet {
            if isSelected {
                mbtiLabel.isEnabledOrHighlighted(isHighlighted: true)
            } else {
                mbtiLabel.isEnabledOrHighlighted(isHighlighted: false)
            }
        }
    }
}

extension MbtiCollectionViewCell {
    func configure(index: String, isSelected: Bool) {
        mbtiLabel.isEnabledOrHighlighted(isHighlighted: isSelected)
    }
}
