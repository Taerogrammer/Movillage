import UIKit

final class CinemaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        [configureButton(), configureNavigation()].forEach { $0 }
    }
}

// MARK: configure button
extension CinemaViewController: ButtonConfiguration {
    func configureButton() {
        print(#function)
    }

}

// MARK: configure navigation
extension CinemaViewController: NavigationConfiguration {
    func configureNavigation() {
        navigationItem.title = "오늘의 영화"
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchTapped))
        searchButton.tintColor = UIColor.customBlue
        navigationItem.rightBarButtonItem = searchButton
    }
}

// MARK: @objc
extension CinemaViewController {
    @objc private func searchTapped() {
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
        setEmptyTitleBackButton()
    }
}
