//
//  TextComponent.swift
//  Movillage
//
//  Created by 김태형 on 1/24/25.
//

import UIKit

final class HeaderLabel: UILabel {

    init() {
        super.init(frame: .zero)
        font = .boldSystemFont(ofSize: 16)

        textColor = .blue
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ContentRegularLabel: UILabel {

    init() {
        super.init(frame: .zero)
        font = .systemFont(ofSize: 14)
        textColor = .red
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ContentBoldLabel: UILabel {

    init() {
        super.init(frame: .zero)
        font = .boldSystemFont(ofSize: 14)
        textColor = .red
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class DescriptionLabel: UILabel {

    init() {
        super.init(frame: .zero)
        font = .boldSystemFont(ofSize: 12)
        textColor = .red
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
