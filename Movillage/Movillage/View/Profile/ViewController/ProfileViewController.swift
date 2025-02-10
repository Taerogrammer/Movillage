import UIKit

final class ProfileViewController: UIViewController {
    private let profileView = ProfileView()

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
        profileView.viewModel.input.completeButtonTapped.value = ()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else { return }

        window.rootViewController = TabBarController()
        window.makeKeyAndVisible()
    }
    @objc private func imageTapped() {
        let vc = ProfileImageViewController()
        vc.viewModel.input.imageIndex.value = profileView.viewModel.output.imageIndex.value

        // TODO: 로직 분리 확인
        vc.contents = { [weak self] idx in
            self?.profileView.viewModel.input.imageIndex.value = idx
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - bind
extension ProfileViewController {
    private func bindData() {
        profileView.viewModel.output.imageName.bind { [weak self] name in
            self?.profileView.imageView.image = UIImage(named: name)
        }
        profileView.viewModel.output.resultText.lazyBind { [weak self] text in
            self?.profileView.textInfoLabel.text = text
        }
        profileView.viewModel.output.resultTextColor.lazyBind { [weak self] color in
            self?.profileView.textInfoLabel.textColor = (color == "blue") ? UIColor.customBlue : UIColor.customRed
        }
        profileView.viewModel.output.buttonIsEnabled.lazyBind { [weak self] enabled in
            self?.profileView.completeButton.isEnabled = enabled
        }
        profileView.viewModel.output.selectedIndex.lazyBind { [weak self] _ in
            DispatchQueue.main.async {
                self?.profileView.mbtiCollectionView.reloadData()
            }
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
        return profileView.viewModel.mbtiList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MbtiCollectionViewCell.id, for: indexPath) as! MbtiCollectionViewCell
        cell.mbtiLabel.text = profileView.viewModel.mbtiList[indexPath.item]

        let selectedIndex = profileView.viewModel.output.selectedIndex.value
        cell.updateCell(indexPath: indexPath, selectedIndex: selectedIndex)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        profileView.viewModel.input.selectedIndex.value = indexPath.item
    }
}
