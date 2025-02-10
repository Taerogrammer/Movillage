import Foundation

final class ProfileImageViewModel {

    private(set) var input: Input
    private(set) var output: Output

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
