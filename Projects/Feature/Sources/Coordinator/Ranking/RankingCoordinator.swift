//
//  RankingCoordinator.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-03.
//

import UIKit

final class RankingCoordinator: RankingBaseCoordinator {
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        let viewController = RankingViewController()
        viewController.coordinator = self
        rootViewController = UINavigationController(rootViewController: viewController)
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String : Any]?) {}
}
