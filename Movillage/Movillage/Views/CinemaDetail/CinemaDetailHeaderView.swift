import UIKit
import SnapKit

// TODO: CinemaHeaderView와 함께 묶기
final class CinemaDetailHeaderView: UICollectionReusableView {
    static let id = "CinemaDetailHeaderView"

    private let titleLabel = UILabel().setFont(.header)
    let moreButton = UIButton()
    var moreButtonToggle: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        [configureHierarchy(), configureLayout(), configureView()].forEach{ $0 }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CinemaDetailHeaderView: ViewConfiguration {
    func configureHierarchy() {
        [titleLabel, moreButton].forEach { addSubview($0) }
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            $0.centerY.equalToSuperview()
        }
        moreButton.snp.makeConstraints {
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configureView() {
        moreButton.setTitle("More", for: .normal)
        moreButton.setTitleColor(UIColor.customBlue, for: .normal)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
    }
    func configureHeaderTitle(title: String) { titleLabel.text = title }
    // selected 아닐 때 확인하기
    func configureMoreButton(title: String) {
        moreButton.isHidden = (title != "Synopsis")
    }
}

// MARK: @objc
extension CinemaDetailHeaderView {
    @objc private func moreButtonTapped() { moreButtonToggle?() }
}
