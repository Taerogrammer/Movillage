import UIKit
import SnapKit

final class UpcomingView: BaseView {
    private let upcomingLabel = UILabel().setFont(.contentRegular)

    override func configureHierarchy() {
        addSubview(upcomingLabel)
    }
    override func configureLayout() {
        upcomingLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    override func configureView() {
        upcomingLabel.text = "추후 업데이트 예정입니다"
    }
}
