import Foundation

final class ProfileImageViewModel {

    private(set) var input: Input
    private(set) var output: Output
    private(set) var profileImageList: [String] = [
        "profile_0", "profile_1", "profile_2", "profile_3",
        "profile_4", "profile_5", "profile_6", "profile_7",
        "profile_8", "profile_9", "profile_10", "profile_11"
    ]

    struct Input {
        let imageIndex: Observable<Int?> = Observable(nil)
        let backButton: Observable<Void> = Observable(())
    }
    struct Output {
        let imageName: Observable<String> = Observable("")
        let imageIndex: Observable<Int?> = Observable(nil)
    }

    init() {
        input = Input()
        output = Output()

        transform()
    }

    private func transform() {
        input.imageIndex.bind { [weak self] idx in
            self?.updateProfileImage()
        }
    }
    private func updateProfileImage() {
        guard let index = input.imageIndex.value else { return }
        output.imageName.value = "profile_\(index)"
        output.imageIndex.value = input.imageIndex.value
    }

}
