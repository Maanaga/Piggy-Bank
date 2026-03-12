//
//  AppCoordinator.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//

import SwiftUI
import UIKit

final class AppCoordinator: CoordinatorProtocol {
    var childCoordinators: [CoordinatorProtocol] = []
    private let window: UIWindow
    private weak var childrenNavigationController: UINavigationController?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let mainTabCoordinator = MainTabCoordinator(window: window, appCoordinator: self)
        addChild(mainTabCoordinator)
        mainTabCoordinator.start()
    }

    func configureChildrenNavigation(_ navigationController: UINavigationController) {
        childrenNavigationController = navigationController
    }

    func showChildInfo(_ viewModel: MyChildrenViewModel) {
        guard let nav = childrenNavigationController else { return }
        let view = ChildInfoView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        nav.pushViewController(vc, animated: true)
        nav.setNavigationBarHidden(false, animated: true)
    }

     func popChildInfo() {
        guard let nav = childrenNavigationController else { return }
        nav.popViewController(animated: true)
        if nav.viewControllers.count == 1 {
            nav.setNavigationBarHidden(true, animated: true)
        }
    }
}
