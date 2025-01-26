import UIKit

final class ProfileEditViewController: UIViewController {

    private let profileEditView = ProfileEditView()

    override func loadView() {
        view = profileEditView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        [configureButton(), configureGesture()].forEach { $0 }
    }
}

// MARK: configure button
extension ProfileEditViewController: ButtonConfiguration {
    func configureButton() {
        profileEditView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        profileEditView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
}

// MARK: @objc
extension ProfileEditViewController {
    @objc private func closeButtonTapped() { dismiss(animated: true) }
    @objc private func saveButtonTapped() {
        print(#function)
    }
}

// MARK: configure etc
extension ProfileEditViewController {
    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileEditView.profileView.imageView.isUserInteractionEnabled = true
        profileEditView.profileView.imageView.addGestureRecognizer(tapGesture)
    }
}

// MARK: @objc
extension ProfileEditViewController {
    @objc private func imageTapped() {
        let vc = ProfileImageViewController()
        present(vc, animated: true)
    }
}
