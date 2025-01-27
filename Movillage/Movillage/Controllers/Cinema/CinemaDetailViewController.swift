import UIKit

final class CinemaDetailViewController: UIViewController {
    private let cinemaDetailView = CinemaDetailView()

    override func loadView() {
        view = cinemaDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "상세 정보"
    }
}
