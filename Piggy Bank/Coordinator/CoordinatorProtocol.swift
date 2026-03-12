//
//  CoordinatorProtocol.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//

import UIKit


protocol CoordinatorProtocol: AnyObject {
    
    var childCoordinators: [CoordinatorProtocol] { get set }

    func start()

    func removeChild(_ coordinator: CoordinatorProtocol)
}

extension CoordinatorProtocol {
    func removeChild(_ coordinator: CoordinatorProtocol) {
        childCoordinators.removeAll { $0 === coordinator }
    }

    func addChild(_ coordinator: CoordinatorProtocol) {
        childCoordinators.append(coordinator)
    }
}
