import UIKit

final class UpcomingViewController: UIViewController {
    private let upcomingView = UpcomingView()

    override func loadView() {
        view = upcomingView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
    }
}

// MARK: configure navigation
extension UpcomingViewController: NavigationConfiguration {
    func configureNavigation() {
        navigationItem.title = "UPCOMING"
    }
}
