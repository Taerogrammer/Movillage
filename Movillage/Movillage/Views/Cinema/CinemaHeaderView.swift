import UIKit
import SnapKit

final class CinemaHeaderView: UICollectionReusableView {
    static let id = "CinemaHeaderView"

    private let titleLabel = UILabel().setFont(.header)
    private let removeButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        [configureHierarchy(), configureLayout(), configureView()].forEach{ $0 }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CinemaHeaderView: ViewConfiguration {
    func configureHierarchy() {
        [titleLabel, removeButton].forEach { addSubview($0) }
    }

    func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            $0.centerY.equalToSuperview()
        }
        removeButton.snp.makeConstraints {
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.centerY.equalToSuperview()
        }
    }

    func configureView() {
        removeButton.setTitle("전체 삭제", for: .normal)
        removeButton.titleLabel?.font = UIFont.contentBold
        removeButton.setTitleColor(UIColor.customBlue, for: .normal)
    }
    func configureHeaderTitle(title: String) { titleLabel.text = title }
    func configureRemoveButton(title: String) { removeButton.isHidden = (title != "최근검색어") }
}
