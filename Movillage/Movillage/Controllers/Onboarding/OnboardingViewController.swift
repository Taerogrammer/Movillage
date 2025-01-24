//
//  OnboardingViewController.swift
//  Movillage
//
//  Created by 김태형 on 1/24/25.
//

import UIKit

final class OnboardingViewController: UIViewController {
    private let onboardingView = OnboardingView()

    override func loadView() {
        view = onboardingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
    }
}
