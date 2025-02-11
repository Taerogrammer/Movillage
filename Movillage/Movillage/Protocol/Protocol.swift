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

protocol RecentSearchCloseDelegate: AnyObject {
    func recentSearchCloseButtonTapped(at index: Int)
}

protocol ImageCellConfiguration: AnyObject {
    func configureImageCell(with urlString: String?)
}

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output

    func transform()
}

protocol ViewModelBind {
    func bindData()
}
