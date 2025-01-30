import UIKit
import SnapKit

final class CinemaDetailFooterView: UICollectionReusableView {
    static let id = "CinemaDetailFooterView"
    private let releaseDateLabel = UILabel().setFont(.description)
    private let starLabel = UILabel().setFont(.description)
    private let genreLabel = UILabel().setFont(.description)

    override init(frame: CGRect) {
        super.init(frame: frame)
        [configureHierarchy(), configureLayout(), configureView()].forEach{ $0 }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CinemaDetailFooterView: ViewConfiguration {
    func configureHierarchy() {
        [releaseDateLabel, starLabel, genreLabel].forEach { addSubview($0) }
    }
    
    func configureLayout() {
        releaseDateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(starLabel.snp.leading)
        }
        starLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        genreLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(starLabel.snp.trailing)
        }
    }
    
    func configureView() {
        releaseDateLabel.text = "􀉉 2024-12-24"
        starLabel.text = " | 􀋃 8.0 | "
        genreLabel.text = "􀎷 액션, 스릴러"
    }
}
