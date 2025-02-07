import Foundation

final class ProfileViewModel {
    // 화면에 접근되었을 때
    let inputViewAppear: Observable<Void> = Observable(())
    let inputImageIndex: Observable<Int?> = Observable(nil)
    let inputNicknameText: Observable<String?> = Observable(nil)
    let inputCompleteButtonTapped: Observable<Void> = Observable(())

    let outputImageName: Observable<String> = Observable("")
    let outputImageIndex: Observable<Int?> = Observable(nil)
    let outputResultText: Observable<String> = Observable("")
    let buttonIsEnabled: Observable<Bool> = Observable(false)

    init() {
        inputViewAppear.bind { [weak self] _ in
            self?.getProfileImage()
        }
        inputImageIndex.lazyBind { [weak self] _ in
            self?.updateProfileImage()
        }
        inputNicknameText.lazyBind { [weak self] text in
            self?.validateNickname(text: text)
        }
        inputCompleteButtonTapped.lazyBind { [weak self] _ in
            self?.configureUserDefaultsManager()
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
        outputImageIndex.value = randomIndex
    }
    private func updateProfileImage() {
        guard let index = inputImageIndex.value else { return }
        outputImageName.value = "profile_\(index)"
        outputImageIndex.value = index
    }
    private func containSpecialCharacter(text: String) -> Bool {
        return text.contains("@") || text.contains("#") || text.contains("$") || text.contains("%")
    }
    private func containsNumber(text: String) -> Bool {
        return text.filter({ $0.isNumber }).count > 0
    }
    private func validateNickname(text: String?) {
        guard let text = text else { return }
        if text.count < 2 || text.count >= 10 {
            outputResultText.value = "2글자 이상 10글자 미만으로 설정해주세요"
            buttonIsEnabled.value = false
        } else if containSpecialCharacter(text: text) {
            outputResultText.value = "닉네임에 @, #, $, % 는 포함할 수 없어요"
            buttonIsEnabled.value = false
        } else if containsNumber(text: text) {
            outputResultText.value = "닉네임에 숫자는 포함할 수 없어요"
            buttonIsEnabled.value = false
        } else {
            outputResultText.value = "사용할 수 있는 닉네임이에요"
            buttonIsEnabled.value = true
        }
    }
    /// dateFormatter의 인스턴스 생성이 상대적으로 무겁지만,
    /// 완료 버튼이 눌릴 때에만 실행되기 때문에 타입 프로퍼티로 관리하여 데이터 영역에 저장해두기보단
    /// 스택 영역에서 실행하고자 하였습니다.
    private func getRegisterDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        return formatter.string(from: Date())
    }
    private func configureUserDefaultsManager() {
        UserDefaultsManager.nickname = inputNicknameText.value
        UserDefaultsManager.profileImage = outputImageName.value
        UserDefaultsManager.registerDate = getRegisterDate()
        UserDefaultsManager.didStart.toggle()
    }
}
