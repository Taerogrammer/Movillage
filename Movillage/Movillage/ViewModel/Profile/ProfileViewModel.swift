import Foundation

final class ProfileViewModel {
    let mbtiList: [String] = ["E", "S", "F", "J", "I", "N", "T", "P"]
    // 화면에 접근되었을 때
    private(set) var input: Input
    private(set) var output: Output

    struct Input {
        let inputViewAppear: Observable<Void> = Observable(())
        let imageIndex: Observable<Int?> = Observable(nil)
        let nicknameText: Observable<String?> = Observable(nil)
        let completeButtonTapped: Observable<Void> = Observable(())
        let selectedIndex: Observable<Int> = Observable(0)
    }
    struct Output {
        let selectedIndex: Observable<[Int]> = Observable([])
        let imageName: Observable<String> = Observable("")
        let imageIndex: Observable<Int?> = Observable(nil)
        let resultText: Observable<String> = Observable("")
        let resultTextColor: Observable<String> = Observable("")
        let textField: Observable<String?> = Observable(nil)
        let buttonIsEnabled: Observable<Bool> = Observable(false)
    }

    private var isValidNickname: Bool = false

    init() {

        input = Input()
        output = Output()

        transform()
    }
    private func transform() {
        input.inputViewAppear.bind { [weak self] _ in
            self?.getProfileImage()
            self?.getNickname()
        }
        input.imageIndex.lazyBind { [weak self] _ in
            self?.updateProfileImage()
        }
        input.nicknameText.lazyBind { [weak self] text in
            self?.validateNickname(text: text)
        }
        input.completeButtonTapped.lazyBind { [weak self] _ in
            self?.configureUserDefaultsManager()
        }
        input.selectedIndex.lazyBind { [weak self] idx in
            self?.selectMbti(index: idx)
        }
    }

    private func getProfileImage() {
        if UserDefaultsManager.profileImage == nil {
            self.getRandomImage()
        } else {
            output.imageName.value = UserDefaultsManager.profileImage ?? "profile_0"
        }
    }
    /// userDefaults에 프로필 이미지 설정이 없을 때 랜덤으로 보여주기
    private func getRandomImage() {
        let randomIndex = (0...11).randomElement()!
        output.imageName.value = "profile_\(randomIndex)"
        output.imageIndex.value = randomIndex
    }
    private func updateProfileImage() {
        guard let index = input.imageIndex.value else { return }
        output.imageName.value = "profile_\(index)"
        output.imageIndex.value = index
    }
    private func containSpecialCharacter(text: String) -> Bool {
        return text.contains("@") || text.contains("#") || text.contains("$") || text.contains("%")
    }
    private func containsNumber(text: String) -> Bool {
        return text.filter({ $0.isNumber }).count > 0
    }
    private func validateNickname(text: String?) {
        guard let text = text else { return }
        if text.count == 0 {
            output.resultText.value = ""
        } else if text.count < 2 || text.count >= 10 {
            output.resultText.value = "2글자 이상 10글자 미만으로 설정해주세요"
            nicknameEnable(is: false)
        } else if containSpecialCharacter(text: text) {
            output.resultText.value = "닉네임에 @, #, $, % 는 포함할 수 없어요"
            nicknameEnable(is: false)
        } else if containsNumber(text: text) {
            output.resultText.value = "닉네임에 숫자는 포함할 수 없어요"
            nicknameEnable(is: false)
        } else {
            output.resultText.value = "사용할 수 있는 닉네임이에요"
            nicknameEnable(is: true)
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
        UserDefaultsManager.nickname = input.nicknameText.value
        UserDefaultsManager.profileImage = output.imageName.value
        UserDefaultsManager.registerDate = getRegisterDate()
        UserDefaultsManager.didStart.toggle()
    }
    private func getNickname() {
        if UserDefaultsManager.nickname != nil {
            output.textField.value = UserDefaultsManager.nickname
            output.resultText.value = "사용할 수 있는 닉네임이에요"  // 사용할 수 있는 닉네임이었기 때문에 설정 가능했던 것
        }
    }
    private func nicknameEnable(is bool: Bool) {
        if bool {
            output.resultTextColor.value = "blue"
            isValidNickname = true
        } else {
            output.resultTextColor.value = "red"
            isValidNickname = false
        }
        isCompleteValid()
    }
    private func selectMbti(index: Int) {
        let groupIndex = getCategoryIndex(for: index)

        // 만약 이미 클릭된 항목이면 취소
        if output.selectedIndex.value.contains(index) {
            output.selectedIndex.value.removeAll { $0 == index }
        } else {
            output.selectedIndex.value.removeAll { getCategoryIndex(for: $0) == groupIndex }
            output.selectedIndex.value.append(index)
        }

        isCompleteValid()
    }
    // 4가지 카테고리 분류
    private func getCategoryIndex(for index: Int) -> Int { return index % 4 }
    /// 완료 버튼: 닉네임 / MBTI 조건 충족시
    private func isCompleteValid() {
        output.buttonIsEnabled.value = isValidNickname && output.selectedIndex.value.count == 4 ? true : false
    }
}
