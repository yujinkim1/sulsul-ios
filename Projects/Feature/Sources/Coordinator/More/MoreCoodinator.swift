//
//  MoreCoodinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit

final class MoreCoordinator: MoreBaseCoordinator {
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        let moreVC = MoreViewController()
        moreVC.coordinator = self
        rootViewController = UINavigationController(rootViewController: moreVC)
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String: Any]?) {
        
    }
}
