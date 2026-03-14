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
    private let userRole: Role
    private let piggyBanks: [PiggyBankGoal]
    private let parentId: Int?
    private let parentIBAN: String?
    private let initialGoalsByChildName: [String: [PiggyBankGoal]]

    init(window: UIWindow, appCoordinator: AppCoordinator, children: [Children], userRole: Role, piggyBanks: [PiggyBankGoal] = [], parentId: Int? = nil, parentIBAN: String? = nil, initialGoalsByChildName: [String: [PiggyBankGoal]] = [:]) {
        self.window = window
        self.appCoordinator = appCoordinator
        self.children = children
        self.userRole = userRole
        self.piggyBanks = piggyBanks
        self.parentId = parentId
        self.parentIBAN = parentIBAN
        self.initialGoalsByChildName = initialGoalsByChildName
    }

    func start() {
        let tabBarController = UITabBarController()
        var viewControllers: [UIViewController] = []

        switch userRole {
        case .parent:
            let childrenNav = UINavigationController()
            appCoordinator?.configureChildrenNavigation(childrenNav)
            let childrenViewModel = MyChildrenViewModel(children: children, parentId: parentId, parentIBAN: parentIBAN, initialGoalsByChildName: initialGoalsByChildName)
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
            childrenNav.tabBarItem.tag = 0
            viewControllers = [childrenNav]

        case .children:
            let childId = children.first?.id
            let bankNav = UINavigationController(rootViewController: makeHostingController(for: ChildMainView(goals: piggyBanks, childId: childId)))
            bankNav.tabBarItem = UITabBarItem(
                title: "Bank",
                image: UIImage(systemName: "banknote"),
                selectedImage: UIImage(systemName: "banknote.fill")
            )
            bankNav.tabBarItem.tag = 0
            viewControllers.append(bankNav)

            let awardsNav = UINavigationController(rootViewController: makeHostingController(for: AwardsView()))
            awardsNav.tabBarItem = UITabBarItem(
                title: "Awards",
                image: UIImage(systemName: "trophy"),
                selectedImage: UIImage(systemName: "trophy.fill")
            )
            awardsNav.tabBarItem.tag = 1
            viewControllers.append(awardsNav)
        }

        tabBarController.setViewControllers(viewControllers, animated: false)
        tabBarController.selectedIndex = 0

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    private func makeHostingController<Content: View>(for view: Content) -> UIHostingController<Content> {
        UIHostingController(rootView: view)
    }
}
