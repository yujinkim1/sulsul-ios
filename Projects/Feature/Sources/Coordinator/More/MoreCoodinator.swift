//
//  MoreCoodinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit

final class MoreCoordinator: MoreBaseCoordinator {
    var currentFlowManager: CurrentFlowManager?
    
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        return UIViewController()
    }
    
    func moveTo(appFlow: Flow, userData: [String: Any]?) {
        guard let tabBarFlow = appFlow.tabBarFlow else {
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
            return
        }
        
        switch tabBarFlow {
        case .more(let profileScene):
            moveToProfileScene(profileScene, userData: userData)
        default:
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
        }
    }
    
    func moveToProfileScene(_ scene: ProfileScene, userData: [String: Any]?) {
        switch scene {
        case .main:
//            let profileViewModel = ProfileViewModel()
            let profileMainVC = ProfileMainViewController()
            profileMainVC.coordinator = self
            currentNavigationViewController?.interactivePopGestureRecognizer?.isEnabled = true
            currentNavigationViewController?.pushViewController(profileMainVC, animated: true)
        }
    }
}
