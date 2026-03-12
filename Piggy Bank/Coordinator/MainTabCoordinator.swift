//
//  MainTabCoordinator.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//

import SwiftUI
import UIKit

final class MainTabCoordinator: CoordinatorProtocol {
    var childCoordinators: [CoordinatorProtocol] = []
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let tabBarController = UITabBarController()

        let bankNav = UINavigationController(rootViewController: makeHostingController(for: ChildMainView()))
        bankNav.tabBarItem = UITabBarItem(
            title: "Bank",
            image: UIImage(systemName: "banknote"),
            selectedImage: UIImage(systemName: "banknote.fill")
        )
        bankNav.tabBarItem.tag = 0

        let awardsNav = UINavigationController(rootViewController: makeHostingController(for: AwardsView()))
        awardsNav.tabBarItem = UITabBarItem(
            title: "Awards",
            image: UIImage(systemName: "trophy"),
            selectedImage: UIImage(systemName: "trophy.fill")
        )
        awardsNav.tabBarItem.tag = 1

        let historyNav = UINavigationController(rootViewController: makeHostingController(for: HistoryView()))
        historyNav.tabBarItem = UITabBarItem(
            title: "History",
            image: UIImage(systemName: "clock.arrow.circlepath"),
            selectedImage: UIImage(systemName: "clock.arrow.circlepath")
        )
        historyNav.tabBarItem.tag = 2

        tabBarController.setViewControllers([bankNav, awardsNav, historyNav], animated: false)
        tabBarController.selectedIndex = 0

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    private func makeHostingController<Content: View>(for view: Content) -> UIHostingController<Content> {
        UIHostingController(rootView: view)
    }
}
