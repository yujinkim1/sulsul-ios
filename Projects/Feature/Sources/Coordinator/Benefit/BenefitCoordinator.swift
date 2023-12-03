//
//  BenefitCoordinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit

final class BenefitCoordinator: BenefitBaseCoordinator {
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        let benefitVC = BenefitViewController()
        benefitVC.coordinator = self
        rootViewController = UINavigationController(rootViewController: benefitVC)
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String: Any]?) {
        
    }
}
