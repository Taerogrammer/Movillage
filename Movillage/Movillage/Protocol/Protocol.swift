//
//  Protocol.swift
//  Movillage
//
//  Created by 김태형 on 1/24/25.
//

import Foundation

protocol ViewConfiguration: AnyObject {
    func configureHierarchy()
    func configureLayout()
    func configureView()
}

protocol ButtonConfiguration: AnyObject {
    func configureButton()
}

protocol NavigationConfiguration: AnyObject {
    func configureNavigation()
}

protocol DelegateConfiguration: AnyObject {
    func configureDelegate()
}

protocol TabBarConfiguration: AnyObject {
    func configureTabBar()
    func configureTabBarAppearance()
}

protocol ProfileCardViewGesture: AnyObject {
    func profileCardTapped()
    func configureProfileCard()
}

protocol NotificationConfiguration: AnyObject {
    func configureNotification()
}
