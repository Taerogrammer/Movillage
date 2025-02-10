import Foundation

final class ProfileCardViewModel {
    private(set) var input: Input
    private(set) var output: Output

    struct Input {
        let profileCardViewLoad: Observable<Void> = Observable(())

    }
    struct Output {
        let nickname: Observable<String?> = Observable(nil)
        let imageName: Observable<String> = Observable("")
        let registerDate: Observable<String> = Observable("")
        let likeCount: Observable<Int> = Observable(0)
    }

    init() {
        input = Input()
        output = Output()

        transform()
    }
    private func transform() {
        input.profileCardViewLoad.bind { [weak self] _ in
            self?.configureData()
        }
    }
    private func configureData() {
        output.imageName.value = UserDefaultsManager.profileImage ?? "profile_0"
        output.nickname.value = UserDefaultsManager.nickname
        output.registerDate.value = UserDefaultsManager.registerDate ?? Date().description
        output.likeCount.value = UserDefaultsManager.favoriteMovie.count

    }
}
