import UIKit
import SnapKit

final class SearchView: BaseView {
    let searchBar = UISearchBar()
    let notFoundLabel = UILabel().setFont(.contentRegular)
    let searchTableView = UITableView()

    override func configureHierarchy() {
        [searchBar, notFoundLabel, searchTableView].forEach { addSubview($0) }
    }
    override func configureLayout() {
        searchBar.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(self.safeAreaLayoutGuide)
        }
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        notFoundLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    override func configureView() {
        searchBar.placeholder = "영화를 검색해보세요."
        notFoundLabel.text = "원하는 검색결과를 찾지 못했습니다"
        notFoundLabel.textColor = UIColor.customWhiteGray

        searchTableView.rowHeight = 160
    }
}
