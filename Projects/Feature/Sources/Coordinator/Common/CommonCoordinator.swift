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
            moveToDetailFeed(userData)
        case .setting:
            moveToSetting()
        case .selectSnack:
            moveToSelectSnackScene()
        case .selectDrink:
            moveToSelectDrinkScene()
        }
    }
    
    private func moveToSelectDrinkScene() {
        let viewModel = SelectDrinkViewModel()
        let selectDrinkVC = SelectDrinkViewController(viewModel: viewModel, selectTasteCase: .store)
        selectDrinkVC.coordinator = self
        currentNavigationViewController?.pushViewController(selectDrinkVC, animated: false)
    }
    
    private func moveToSelectSnackScene() {
        let viewModel = SelectSnackViewModel()
        let selectSnackVC = SelectSnackViewController(viewModel: viewModel, selectTasteCase: .store)
        selectSnackVC.coordinator = self
        currentNavigationViewController?.pushViewController(selectSnackVC, animated: true)
    }
    
    private func moveToSetting() {
        let profileSettingVC = ProfileSettingViewController()
        profileSettingVC.coordinator = self
        currentNavigationViewController?.pushViewController(profileSettingVC, animated: true)
    }
    
    private func moveToDetailFeed(_ userData: [String: Any]?) {
        guard let feedId = userData?["feedId"] as? Int else { return }
        
//        let viewModel = DetailFeedViewModel(feedID: feedId)
        let viewController = DetailFeedViewController(feedID: feedId)
        currentNavigationViewController?.pushViewController(viewController, animated: true)
        }

    private func moveToComment() {
        let vc = CommentViewController()
        currentNavigationViewController?.pushViewController(vc, animated: true)
    }
    
    private func moveToSearch() {
        let vc = SearchViewController()
        vc.coordinator = self
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
        let vc = WriteTitleViewController()
        vc.coordinator = self
        
        currentNavigationViewController?.pushViewController(vc, animated: true)
    }
    
    private func moveToReportContent(_ userData: [String: Any]?) {
        guard let targetId = userData?["targetId"] as? Int else { return }
        guard let reportType = userData?["reportType"] as? ReportType else { return }
        
        let viewModel = ReportViewModel(reportType: reportType, targetId: targetId)
        let vc = ReportViewController(viewModel: viewModel)
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
