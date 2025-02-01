import UIKit
import SnapKit

final class OnboardingView: BaseView {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let contentsLabel = UILabel().setFont(.contentRegular)
    let startButton = CustomButton()

    override func configureHierarchy() {
        [imageView, titleLabel, contentsLabel, startButton].forEach { addSubview($0) }
    }
    override func configureLayout() {
        imageView.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(280)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        contentsLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        startButton.snp.makeConstraints {
            $0.top.equalTo(contentsLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.bottom.lessThanOrEqualTo(self.safeAreaLayoutGuide).inset(16)
        }
    }
    override func configureView() {
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "onboarding")

        titleLabel.text = "Onboarding"
        titleLabel.font = .italicSystemFont(ofSize: 44)

        contentsLabel.text = "당신이 원하는 영화가 가득한 마을," + "\n" + "Movillage를 시작해보세요!"
        contentsLabel.numberOfLines = 2
        contentsLabel.textAlignment = .center

        startButton.setTitle("시작하기", for: .normal)
    }
}
