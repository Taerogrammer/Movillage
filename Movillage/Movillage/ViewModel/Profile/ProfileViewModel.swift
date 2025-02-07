import Foundation

final class ProfileViewModel {
    // 화면에 접근되었을 때
    let inputViewAppear: Observable<Void> = Observable(())

    let outputImageName: Observable<String> = Observable("")


    init() {
        inputViewAppear.bind { [weak self] _ in
            self?.getProfileImage()
        }
    }

    private func getProfileImage() {
        if UserDefaultsManager.profileImage == nil {
            self.getRandomImage()
        } else {
            outputImageName.value = UserDefaultsManager.profileImage ?? "profile_0"
        }
    }
    /// userDefaults에 프로필 이미지 설정이 없을 때 랜덤으로 보여주기
    private func getRandomImage() {
        let randomIndex = (0...11).randomElement()!
        outputImageName.value = "profile_\(randomIndex)"
    }

}
