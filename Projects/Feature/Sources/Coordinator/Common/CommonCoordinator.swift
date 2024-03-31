//
//  CommonCoordinator.swift
//  Feature
//
//  Created by 이범준 on 1/13/24.
//

import UIKit

final class CommonCoordinator: CommonBaseCoordinator {
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
        case .common(let commonScene):
            moveToCommonScene(commonScene, userData: userData)
        default:
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
        }
    }
    
    private func moveToCommonScene(_ scene: CommonScene, userData: [String: Any]?) {
        switch scene {
        case .web:
            moveToTermsWebScene(userData)
        case .selectPhoto:
            moveToSelectPhoto()
        case .writePostText:
            moveToWritePostText(userData)
        case .writeContent:
            moveToWriteContent(userData)
        case .reportContent:
            moveToReportContent(userData)
        case .search:
            moveToSearch()
        case .comment:
            moveToComment()
        case .detailFeed:
            moveToDetailFeed()
        }
    }
    
    private func moveToDetailFeed() {
        let vc = DetailFeedViewController() // feedID를 전달하지 않으면 기본 0
        currentNavigationViewController?.pushViewController(vc, animated: true)
    }
    
    private func moveToComment() {
        let vc = CommentViewController()
        currentNavigationViewController?.pushViewController(vc, animated: true)
    }
    
    private func moveToSearch() {
        let vc = SearchViewController()
        currentNavigationViewController?.pushViewController(vc, animated: true)
    }
    
    private func moveToWriteContent(_ userData: [String: Any]?) {
        guard let images = userData?["images"] as? [UIImage] else { return }

        let vc = WriteContentViewController()
        vc.setSelectedImages(images)
        vc.coordinator = self
        
        currentNavigationViewController?.pushViewController(vc, animated: true)
    }
    
    private func moveToWritePostText(_ userData: [String: Any]?) {
        guard let images = userData?["images"] as? [UIImage] else { return }
        
        let vc = WriteTitleViewController()
        vc.setSelectedImages(images)
        vc.coordinator = self
        
        currentNavigationViewController?.pushViewController(vc, animated: true)
    }
    
    private func moveToSelectPhoto() {
        let vc = SelectPhotoViewController()
        vc.coordinator = self
        
        currentNavigationViewController?.pushViewController(vc, animated: true)
    }
    
    private func moveToReportContent(_ userData: [String: Any]?) {
        let vc = ReportViewController()
        vc.coordinator = self
        
        currentNavigationViewController?.pushViewController(vc, animated: true)
    }
    
    private func moveToTermsWebScene(_ userData: [String: Any]?) {
        guard let url = userData?["url"] as? URL else { return }
        
//        let webVC = BaseWebViewController(url: url)
//        webVC.coordinator = self
//        
//        currentNavigationViewController?.pushViewController(webVC, animated: true)
    }
}
