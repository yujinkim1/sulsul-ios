//
//  TransferHistoryCoordinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit

final class TransferHistoryCoordinator: TransferHistoryBaseCoordinator {
    var currentFlowManager: CurrentFlowManager?
    
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        return UIViewController()
    }
    
    func moveTo(appFlow: Flow, userData: [String: Any]?) {
        
    }
}
