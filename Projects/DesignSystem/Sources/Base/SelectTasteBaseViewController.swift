//
//  SelectTasteBaseViewController.swift
//  DesignSystem
//
//  Created by 이범준 on 12/9/23.
//

import UIKit
import SnapKit
import Then

open class SelectTasteBaseViewController: BaseViewController {

    var buttonBottomConstraint: Constraint?
    
    lazy var topView = BaseTopView()
    
    public lazy var nextButtonBackgroundView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.black.color
        $0.layer.shadowColor = DesignSystemAsset.black.color.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: -40)
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 20
    }
    
    public lazy var submitTouchableLabel = IndicatorTouchableView().then {
        $0.text = "다음"
        $0.textColor = DesignSystemAsset.gray200.color
        $0.backgroundColor = DesignSystemAsset.main.color
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.clipsToBounds = true
    }
    
    open override func addViews() {
        view.addSubviews([topView,
                          nextButtonBackgroundView])
        nextButtonBackgroundView.addSubview(submitTouchableLabel)
    }
    
    open override func makeConstraints() {
        topView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(getSafeAreaTop())
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 40))
        }
        
        nextButtonBackgroundView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 89))
            $0.width.bottom.centerX.equalToSuperview()
        }
        
        submitTouchableLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 52))
            
            let offset = getSafeAreaBottom() + moderateScale(number: 12)
            buttonBottomConstraint = $0.bottom.equalToSuperview().inset(offset).constraint
        }
    }

}
