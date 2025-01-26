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

        // 해당 init이 마지막에 호출되어 backgroundColor를 수정해도 덮어쓰여짐
        // 만약 backgroundColor가 없다면 black으로 지정
        if backgroundColor == nil { backgroundColor = .customBlack }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() { }
}
