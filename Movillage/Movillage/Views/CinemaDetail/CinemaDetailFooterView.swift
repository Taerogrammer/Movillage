import UIKit
import SnapKit

final class CinemaDetailFooterView: UICollectionReusableView {
    static let id = "CinemaDetailFooterView"
    private let calendarImage = UIImageView(image: UIImage(systemName: "calendar"))
    private let starImage = UIImageView(image: UIImage(systemName: "star.fill"))
    private let filmImage = UIImageView(image: UIImage(systemName: "film.fill"))
    let releaseDateLabel = UILabel().setFont(.description)
    let starLabel = UILabel().setFont(.description)
    let genreLabel = UILabel().setFont(.description)
    let pageControl = UIPageControl()

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
        [calendarImage, releaseDateLabel, starImage, starLabel, filmImage, genreLabel, pageControl].forEach { addSubview($0) }
    }
    
    func configureLayout() {
        calendarImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(releaseDateLabel.snp.leading)
            $0.width.height.equalTo(12)
        }
        releaseDateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(starImage.snp.leading)
        }
        starImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(starLabel.snp.leading)
            $0.width.height.equalTo(12)
        }
        starLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        filmImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(starLabel.snp.trailing)
            $0.width.height.equalTo(12)
        }
        genreLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(filmImage.snp.trailing)
        }

        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(48)
        }
    }
    
    func configureView() {
        [calendarImage, releaseDateLabel, starImage, starLabel, filmImage, genreLabel].forEach { _ in tintColor = UIColor.customWhiteGray }
    }
}

extension CinemaDetailFooterView {
    func configureCell(with data: FooterDTO) {
        releaseDateLabel.text = "  " + data.release_date + "  |  "
        starLabel.text = "  " + String(format: "%.1f", data.vote_average) + "  |  "
        genreLabel.text = "  "

        let genreID = data.genre_ids.prefix(2)
        let genreText = genreID.map { MovieGenre.genreDescription(id: $0) }.joined(separator: ", ")
        genreLabel.text! += genreText
    }
}
