import UIKit
import SnapKit

final class SettingView: BaseView {
    let profileCardView = ProfileCardView()
    let tableView = UITableView()

    override func configureHierarchy() {
        [profileCardView, tableView].forEach { addSubview($0) }
    }
    override func configureLayout() {
        profileCardView.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(self.safeAreaLayoutGuide).inset(8)
            $0.height.greaterThanOrEqualTo(136)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(profileCardView.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        tableView.rowHeight = 44
    }
    override func configureView() {
    }
}

