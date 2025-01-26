import UIKit

final class ProfileEditViewController: UIViewController {

    private let profileEditView = ProfileEditView()

    override func loadView() {
        view = profileEditView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
