//
//  BenefitCoordinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit

final class BenefitCoordinator: BenefitBaseCoordinator {
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
        case .benefit(let benefitScene):
            moveToBenefitScene(benefitScene, userData: nil)
        default:
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
        }
    }
    
    func moveToBenefitScene(_ scene: BenefitScene, userData: [String: Any]?) {
        switch scene {
        case .main:
            let benefitVC = BenefitViewController()
            benefitVC.coordinator = self
            currentNavigationViewController?.pushViewController(benefitVC, animated: true)
        }
    }
}
