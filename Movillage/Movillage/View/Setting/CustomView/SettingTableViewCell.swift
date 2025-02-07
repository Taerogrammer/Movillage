import UIKit
import SnapKit

final class SettingTableViewCell: BaseTableViewCell {
    static let id = "SettingTableViewCell"

    let label = UILabel().setFont(.contentRegular)

    override func configureHierarchy() {
        contentView.addSubview(label)
    }
    override func configureLayout() {
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.safeAreaLayoutGuide).inset(8)
        }
    }
    override func configureView() {
    }
}

// MARK: configure cell data
extension SettingTableViewCell {
    func configureCell(content: String) { label.text = content }
}
