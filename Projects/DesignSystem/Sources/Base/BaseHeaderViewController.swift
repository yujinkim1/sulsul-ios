//
//  BaseHeaderViewController.swift
//  DesignSystem
//
//  Created by 김유진 on 2/15/24.
//

import UIKit

open class BaseHeaderViewController: BaseViewController {
    lazy var headerView = UIView()
    
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "common_leftArrow")?.withTintColor(DesignSystemAsset.gray900.color), for: .normal)
    }
    
    lazy var titleLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 18)
    }
    
    lazy var actionButton = UILabel().then {
        $0.textColor = DesignSystemAsset.main.color
        $0.font = Font.semiBold(size: 14)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        makeConstraints()
    }
    
    open override func addViews() {
        super.addViews()
        
        view.addSubview(headerView)
        
        headerView.addSubviews([
            backButton,
            titleLabel,
            actionButton
        ])
    }
    
    open override func makeConstraints() {
        super.makeConstraints()
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.centerX.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 52))
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(moderateScale(number: 20))
        }
    }
}
