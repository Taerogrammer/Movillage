import UIKit

final class ProfileViewController: UIViewController {
    private let profileView = ProfileView()

    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
    }
}

// MARK: configure button
extension ProfileViewController: ButtonConfiguration {
    func configureButton() {
        profileView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
}

// MARK: method
extension ProfileViewController {
    private func configureImage() {
    }
}

// MARK: @objc
extension ProfileViewController {
    @objc private func completeButtonTapped() {
        print(#function)
    }
}
