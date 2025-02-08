import UIKit

final class ProfileViewController: UIViewController {
    private let profileView = ProfileView()
    let mbtiList: [String] = ["E", "I", "S", "N", "F", "T", "J", "p"]

    override func loadView() {
        view = profileView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        [configureButton(), configureNavigation(), configureGesture(), bindData(), configureDelegate()].forEach { $0 }
    }
}

// MARK: configure button
extension ProfileViewController: ButtonConfiguration {
    func configureButton() {
        profileView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    }
}

// MARK: configure navigation
extension ProfileViewController: NavigationConfiguration {
    func configureNavigation() {
        navigationItem.title = "프로필 설정"
        setEmptyTitleBackButton()
    }
}

// MARK: configure etc
extension ProfileViewController {
    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileView.imageView.isUserInteractionEnabled = true
        profileView.imageView.addGestureRecognizer(tapGesture)
    }
}

// MARK: @objc
extension ProfileViewController {
    @objc private func completeButtonTapped() {
        profileView.viewModel.inputCompleteButtonTapped.value = ()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }

        window.rootViewController = TabBarController()
        window.makeKeyAndVisible()
    }
    @objc private func imageTapped() {
        let vc = ProfileImageViewController()
        vc.viewModel.inputImageIndex.value = profileView.viewModel.outputImageIndex.value

        // TODO: 로직 분리 확인
        vc.contents = { [weak self] idx in
            self?.profileView.viewModel.inputImageIndex.value = idx
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - bind
extension ProfileViewController {
    private func bindData() {
        profileView.viewModel.outputImageName.bind { [weak self] name in
            self?.profileView.imageView.image = UIImage(named: name)
        }
        profileView.viewModel.outputResultText.lazyBind { [weak self] text in
            self?.profileView.textInfoLabel.text = text
        }
        profileView.viewModel.outputResultTextColor.lazyBind { [weak self] color in
            self?.profileView.textInfoLabel.textColor = (color == "blue") ? UIColor.customBlue : UIColor.customRed
        }
        profileView.viewModel.buttonIsEnabled.lazyBind { [weak self] enabled in
            self?.profileView.completeButton.isEnabled = enabled
        }
    }
}

// MARK: - configure delegate
extension ProfileViewController: DelegateConfiguration {
    func configureDelegate() {
        profileView.mbtiCollectionView.delegate = self
        profileView.mbtiCollectionView.dataSource = self
        profileView.mbtiCollectionView.register(MbtiCollectionViewCell.self, forCellWithReuseIdentifier: MbtiCollectionViewCell.id)
    }
}

// MARK: - configure collection view
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mbtiList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MbtiCollectionViewCell.id, for: indexPath) as! MbtiCollectionViewCell

        cell.mbtiLabel.text = mbtiList[indexPath.item]

        return cell
    }
    

}
