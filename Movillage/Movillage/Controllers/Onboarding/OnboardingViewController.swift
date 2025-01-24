import UIKit

final class OnboardingViewController: UIViewController {
    private let onboardingView = OnboardingView()

    override func loadView() {
        view = onboardingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
    }
}

// MARK: configure button
extension OnboardingViewController: ButtonConfiguration {
    func configureButton() {
        onboardingView.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
}

// MARK: @objc
extension OnboardingViewController {
    @objc private func startButtonTapped() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
