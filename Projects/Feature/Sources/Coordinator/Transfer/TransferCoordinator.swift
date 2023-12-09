//
//  TransferCoordinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit

final class TransferCoordinator: TransferBaseCoordinator {
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
//        let viewModel = TransferViewModel(usecase: AppContainer.shared.resolve(TransferUsecaseProtocol.self)!)
        let transferVC = TransferViewController()
        transferVC.coordinator = self
        rootViewController = UINavigationController(rootViewController: transferVC)
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String: Any]?) {
        
    }
}
