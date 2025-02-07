import Foundation

final class ProfileCardViewModel {
    let profileCardViewLoad: Observable<Void> = Observable(())

    let outputNickname: Observable<String?> = Observable(nil)
    let outputImageName: Observable<String> = Observable("")
    let outputRegisterDate: Observable<String> = Observable("")
    let outputLikeCount: Observable<Int> = Observable(0)

    init() {
        profileCardViewLoad.bind { [weak self] _ in
            self?.configureData()
        }
    }
    private func configureData() {
        outputImageName.value = UserDefaultsManager.profileImage ?? "profile_0"
        outputNickname.value = UserDefaultsManager.nickname
        outputRegisterDate.value = UserDefaultsManager.registerDate ?? Date().description
        outputLikeCount.value = UserDefaultsManager.favoriteMovie.count
        
    }
}
