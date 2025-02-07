import Foundation

final class ProfileEditViewModel {

    let editViewDidLoad: Observable<Void> = Observable(())
    let inputImageIndex: Observable<Int?> = Observable(nil)
    let inputSaveButtonTapped: Observable<Void> = Observable(())
    let inputNicknameText: Observable<String?> = Observable(nil)
    let outputImageName: Observable<String?> = Observable(nil)
    let outputImageIndex: Observable<Int?> = Observable(nil)

    init() {
        editViewDidLoad.bind { [weak self] _ in
            self?.getProfileData()
        }
        inputImageIndex.lazyBind { [weak self] _ in
            self?.updateProfileImage()
        }
        inputSaveButtonTapped.lazyBind { [weak self] _ in
            self?.saveButtonTapped()
        }
    }
    private func getProfileData() {
        [getProfileImageName(), getProfileImageIndex()].forEach { $0 }
    }
    private func getProfileImageName() {
        outputImageName.value = UserDefaultsManager.profileImage
    }
    private func getProfileImageIndex() {
        guard let candidateIndex = UserDefaultsManager.profileImage else { return }
        let index = candidateIndex.filter { $0.isNumber }
        outputImageIndex.value = Int(index)
    }
    private func updateProfileImage() {
        guard let index = inputImageIndex.value else { return }
        outputImageName.value = "profile_\(index)"
        outputImageIndex.value = index
    }
    private func saveButtonTapped() {
        guard let index = outputImageIndex.value else { return }
        UserDefaultsManager.profileImage = "profile_\(index)"
        UserDefaultsManager.nickname = inputNicknameText.value
        configureNotification()
    }
}

// MARK: configure notification
extension ProfileEditViewModel: NotificationConfiguration {
    func configureNotification() { NotificationCenter.default.post(name: NSNotification.Name("updateProfile"), object: nil) }
}
