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
    private weak var appCoordinator: AppCoordinator?
    private let children: [Children]

    init(window: UIWindow, appCoordinator: AppCoordinator, children: [Children]) {
        self.window = window
        self.appCoordinator = appCoordinator
        self.children = children
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

        let childrenNav = UINavigationController()
        appCoordinator?.configureChildrenNavigation(childrenNav)
        let childrenViewModel = MyChildrenViewModel(children: children)
        childrenViewModel.onChildSelected = { [weak self] child in
            childrenViewModel.selectChild(child)
            self?.appCoordinator?.showChildInfo(childrenViewModel)
        }
        childrenViewModel.onBack = { [weak self] in
            childrenViewModel.clearSelectedChild()
            self?.appCoordinator?.popChildInfo()
        }
        let childrenView = MyChildrenView(viewModel: childrenViewModel)
        childrenNav.setViewControllers([UIHostingController(rootView: childrenView)], animated: false)
        childrenNav.tabBarItem = UITabBarItem(
            title: "Children",
            image: UIImage(systemName: "person.2"),
            selectedImage: UIImage(systemName: "person.2.fill")
        )
        childrenNav.tabBarItem.tag = 2

        tabBarController.setViewControllers([bankNav, awardsNav, childrenNav], animated: false)
        tabBarController.selectedIndex = 0

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    private func makeHostingController<Content: View>(for view: Content) -> UIHostingController<Content> {
        UIHostingController(rootView: view)
    }
}
