//
//  AppCoordinator.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//

import UIKit

final class AppCoordinator: CoordinatorProtocol {
    var childCoordinators: [CoordinatorProtocol] = []
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let mainTabCoordinator = MainTabCoordinator(window: window)
        addChild(mainTabCoordinator)
        mainTabCoordinator.start()
    }
}
