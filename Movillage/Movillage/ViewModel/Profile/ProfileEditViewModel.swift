import Foundation

final class ProfileEditViewModel {

    private(set) var input: Input
    private(set) var output: Output

    struct Input {
        let editViewDidLoad: Observable<Void> = Observable(())
        let imageIndex: Observable<Int?> = Observable(nil)
        let saveButtonTapped: Observable<Void> = Observable(())
        let nicknameText: Observable<String?> = Observable(nil)
    }
    struct Output {
        let imageName: Observable<String?> = Observable(nil)
        let imageIndex: Observable<Int?> = Observable(nil)
    }

    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    private func transform() {
        input.editViewDidLoad.bind { [weak self] _ in
            self?.getProfileData()
        }
        input.imageIndex.lazyBind { [weak self] _ in
            self?.updateProfileImage()
        }
        input.saveButtonTapped.lazyBind { [weak self] _ in
            self?.saveButtonTapped()
        }
    }
    private func getProfileData() {
        [getProfileImageName(), getProfileImageIndex()].forEach { $0 }
    }
    private func getProfileImageName() {
        output.imageName.value = UserDefaultsManager.profileImage
    }
    private func getProfileImageIndex() {
        guard let candidateIndex = UserDefaultsManager.profileImage else { return }
        let index = candidateIndex.filter { $0.isNumber }
        output.imageIndex.value = Int(index)
    }
    private func updateProfileImage() {
        guard let index = input.imageIndex.value else { return }
        output.imageName.value = "profile_\(index)"
        output.imageIndex.value = index
    }
    private func saveButtonTapped() {
        guard let index = output.imageIndex.value else { return }
        UserDefaultsManager.profileImage = "profile_\(index)"
        UserDefaultsManager.nickname = input.nicknameText.value
        configureNotification()
    }
}

// MARK: configure notification
extension ProfileEditViewModel: NotificationConfiguration {
    func configureNotification() { NotificationCenter.default.post(name: NSNotification.Name("updateProfile"), object: nil) }
}
