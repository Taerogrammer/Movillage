import UIKit

final class ProfileImageViewController: UIViewController {
    let profileImageView = ProfileImageView()
    let profileImageList: [String] = [
        "profile_0", "profile_1", "profile_2", "profile_3",
        "profile_4", "profile_5", "profile_6", "profile_7",
        "profile_8", "profile_9", "profile_10", "profile_11"
    ]
    var imageIndex: Int? {
        didSet { updateProfileImage() }
    }
    var contents: ((Int) -> Void)?

    override func loadView() {
        view = profileImageView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        [configureNavigation(), configureDelegate()].forEach { $0 }
    }
}

// MARK: configure navigation
extension ProfileImageViewController: NavigationConfiguration {
    func configureNavigation() {
        title = "프로필 이미지 편집"

        // TODO: 스와이프로 처리해보기
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = UIColor.customBlue
        navigationItem.leftBarButtonItem = backButton
    }
}

// MARK: @objc
extension ProfileImageViewController {
    @objc private func backButtonTapped() {
        contents?(imageIndex!)
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
        cell.configureCell(index: profileImageList[indexPath.item], isSelected: indexPath.item == imageIndex)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageIndex = indexPath.item
        collectionView.reloadData()
    }
}

// MARK: method
extension ProfileImageViewController {
    private func updateProfileImage() {
        guard let index = imageIndex else { return }
        profileImageView.configureProfileImage(to: "profile_\(index)")
    }
}
