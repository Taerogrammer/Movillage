//
//  BaseView.swift
//  Movillage
//
//  Created by 김태형 on 1/24/25.
//

import UIKit

class BaseView: UIView, ViewConfiguration {

    override init(frame: CGRect) {
        super.init(frame: frame)
        [configureHierarchy(), configureLayout(), configureView()].forEach{ $0 }
        backgroundColor = .customBlack
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() { }
}
