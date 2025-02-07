import Foundation

final class ProfileImageViewModel {
    let inputImageIndex: Observable<Int?> = Observable(nil)

    let outputImageName: Observable<String> = Observable("")
    let outputImageIndex: Observable<Int?> = Observable(nil)


    init() {
        inputImageIndex.bind { [weak self] idx in
            self?.updateProfileImage()
        }
    }
    private func updateProfileImage() {
        guard let index = inputImageIndex.value else { return }
        outputImageName.value = "profile_\(index)"
    }
}
