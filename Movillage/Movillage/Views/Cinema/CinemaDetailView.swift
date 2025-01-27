import UIKit
import SnapKit

final class CinemaDetailView: BaseView {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    var imageView = UIImageView()
    var pageControl = UIPageControl()
    let emptyView = UIView()
    let label = UILabel()
    var backdropArray: [String] = [] {
        didSet {
            print("변경됨")
        }
    }

    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        [imageView, pageControl, emptyView, label].forEach { contentView.addSubview($0) }
    }
    override func configureLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints {
            $0.width.equalTo(scrollView.snp.width)
            $0.verticalEdges.equalTo(scrollView)
        }
        imageView.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.height.equalTo(280)
        }
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(imageView.snp.bottom).offset(-10)
        }

        emptyView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(800)
        }

        label.snp.makeConstraints {
            $0.top.equalTo(emptyView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(contentView).offset(-20)
        }

    }
    override func configureView() {

        scrollView.showsVerticalScrollIndicator = false
        contentView.backgroundColor = .blue

        imageView.backgroundColor = .red
        imageView.image = UIImage(systemName: "heart")

        emptyView.backgroundColor = .purple

        pageControl.numberOfPages = 3
        pageControl.currentPage = 0


        label.text = "ㅣ아ㅜ미아ㅜ미나ㅜ미"

    }
}
