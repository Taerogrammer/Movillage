//
//  BaseView.swift
//  Movillage
//
//  Created by 김태형 on 1/24/25.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BaseView: ViewConfiguration {
    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() { }
}
