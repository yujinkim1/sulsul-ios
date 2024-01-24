//
//  HomeViewController.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit
import DesignSystem

final class HomeViewController: BaseViewController {
    var coordinator: HomeBaseCoordinator?
    
    private lazy var loginButton = TouchableView().then({
        $0.backgroundColor = .red
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
    
    override func addViews() {
        view.addSubview(loginButton)
    }
    
    override func makeConstraints() {
        loginButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 50))
        }
    }
    
    override func setupIfNeeded() {
        loginButton.setOpaqueTapGestureRecognizer { [weak self] in
            self?.coordinator?.moveTo(appFlow: TabBarFlow.auth(.login), userData: nil)
        }
    }
}
