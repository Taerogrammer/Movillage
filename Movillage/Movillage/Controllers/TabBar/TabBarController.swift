import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        [configureTabBar(), configureTabBarAppearance()].forEach { $0 }
    }
}

extension TabBarController: TabBarConfiguration {

    func configureTabBar() {
        let cinemaVC = CinemaViewController()
        let cinemaNav = UINavigationController(rootViewController: cinemaVC)
        let upcomingVC = UpcomingViewController()
        let upcomingNav = UINavigationController(rootViewController: upcomingVC)
        let settingVC = SettingViewController()
        let settingNav = UINavigationController(rootViewController: settingVC)


        cinemaNav.tabBarItem.title = "CINEMA"
        cinemaNav.tabBarItem.image = UIImage(systemName: "popcorn")
        cinemaNav.tabBarItem.selectedImage = UIImage(systemName: "popcorn.fill")

        upcomingNav.tabBarItem.title = "UPCOMING"
        upcomingNav.tabBarItem.image = UIImage(systemName: "film")
        upcomingNav.tabBarItem.selectedImage = UIImage(systemName: "film.fill")

        settingNav.tabBarItem.title = "PROFILE"
        settingNav.tabBarItem.image = UIImage(systemName: "person.circle")
        settingNav.tabBarItem.selectedImage = UIImage(systemName: "person.circle.fill")

        setViewControllers([cinemaNav, upcomingNav, settingNav], animated: true)

    }

    func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .customBlack
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = UIColor.customBlue
    }


}
