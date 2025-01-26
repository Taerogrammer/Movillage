import UIKit
import SnapKit

final class CinemaView: BaseView {

    let profileCardView = ProfileCardView()

    override func configureHierarchy() {
        [profileCardView].forEach { addSubview($0) }
    }
    override func configureLayout() {
        profileCardView.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(self.safeAreaLayoutGuide).inset(8)
            $0.height.greaterThanOrEqualTo(136)
        }
    }

    override func configureView() {
    }
}
