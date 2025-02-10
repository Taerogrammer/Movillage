import UIKit

final class ProfileImageViewController: UIViewController {
    let viewModel = ProfileImageViewModel()
    let profileImageView = ProfileImageView()
    let profileImageList: [String] = [
        "profile_0", "profile_1", "profile_2", "profile_3",
        "profile_4", "profile_5", "profile_6", "profile_7",
        "profile_8", "profile_9", "profile_10", "profile_11"
    ]
    var contents: ((Int) -> Void)?

    override func loadView() {
        view = profileImageView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        [configureNavigation(), configureDelegate(), bindData()].forEach { $0 }
    }
}

// MARK: configure navigation
extension ProfileImageViewController: NavigationConfiguration {
    func configureNavigation() {
        title = "프로필 이미지 편집"

        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = UIColor.customBlue
        navigationItem.leftBarButtonItem = backButton
    }
}

// MARK: @objc
extension ProfileImageViewController {
    @objc private func backButtonTapped() {
        contents?(viewModel.output.imageIndex.value ?? 0)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: configure delegate
extension ProfileImageViewController: DelegateConfiguration {
    func configureDelegate() {
        profileImageView.profileImageCollectionView.delegate = self
        profileImageView.profileImageCollectionView.dataSource = self
        profileImageView.profileImageCollectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.id)
    }
}

// MARK: configure collection view
extension ProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return profileImageList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.id, for: indexPath) as! ProfileImageCollectionViewCell

        // TODO: 고민
        cell.configureCell(index: profileImageList[indexPath.item], isSelected: indexPath.item == viewModel.output.imageIndex.value)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.input.imageIndex.value = indexPath.item
        collectionView.reloadData()
    }
}

// MARK: - bind
extension ProfileImageViewController {
    private func bindData() {
        viewModel.output.imageName.bind { [weak self] name in
            self?.profileImageView.configureProfileImage(to: name)
        }
        viewModel.output.imageIndex.bind { [weak self] idx in
            self?.profileImageView.profileImageCollectionView.selectItem(at: IndexPath(item: idx ?? 0, section: 0), animated: true, scrollPosition: .init())
        }

    }
}
