//
//  RankingCoordinator.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-03.
//

import UIKit

final class RankingCoordinator: NSObject, RankingBaseCoordinator {
    var currentFlowManager: CurrentFlowManager?
    
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        let viewModel = RankingViewModel()
        let viewController = RankingViewController(viewModel: viewModel)
        
        viewController.coordinator = self
        rootViewController = UINavigationController(rootViewController: viewController)
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String: Any]?) {
        guard let tabBarFlow = appFlow.tabBarFlow else {
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
            return
        }
        
        switch tabBarFlow {
        case .ranking(let rankingScene):
            moveToRankingScene(rankingScene, userData: userData)
        default:
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
        }
    }
    
    func moveToRankingScene(_ scene: RankingScene, userData: [String: Any]?) {
        switch scene {
        case .main:
            rootNavigationController?.popToRootViewController(animated: true)
        }
    }
}

// MARK: - UINavigationController Delegate

extension RankingCoordinator: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        guard viewController is RankingViewController else { return }
        
        let tabBarController = parentCoordinator?.rootViewController as? UITabBarController
        tabBarController?.setTabBarHidden(false)
    }
}
