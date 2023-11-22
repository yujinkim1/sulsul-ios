//
//  TransferHistoryCoordinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit

final class TransferHistoryCoordinator: TransferHistoryBaseCoordinator {
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
//        let viewModel = TransferHistoryViewModel(usecase: AppContainer.shared.resolve(TransferHistoryUsecaseProtocol.self)!)
        let transferHistoryVC = TransferHistoryViewController()
        transferHistoryVC.coordinator = self
        rootViewController = UINavigationController(rootViewController: transferHistoryVC)
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String: Any]?) {
        
    }
}
