import Foundation

final class ProfileEditViewModel {

    let editViewDidLoad: Observable<Void> = Observable(())
    let outputImageName: Observable<String?> = Observable(nil)
    let outputImageIndex: Observable<Int?> = Observable(nil)

    init() {
        editViewDidLoad.bind { [weak self] _ in
            self?.getProfileData()
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
}
