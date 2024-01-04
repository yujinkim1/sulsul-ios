//
//  BaseTopView.swift
//  DesignSystem
//
//  Created by 이범준 on 12/9/23.
//

import UIKit
import SnapKit
import Then

public final class BaseTopView: UIView {
    lazy var backTouchableView = TouchableView()
    
    private lazy var backImageView = UIImageView().then {
        $0.image = UIImage(named: "BackButton")
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var closeTouchableView = TouchableView().then {
        $0.isHidden = true
    }
    
    private lazy var closeImageView = UIImageView().then {
        $0.image = UIImage(named: "CloseButton")
        $0.contentMode = .scaleAspectFit
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        let buttonMargin: CGFloat = 5
        
        addSubviews([backTouchableView, closeTouchableView])
        backTouchableView.addSubview(backImageView)
        closeTouchableView.addSubview(closeImageView)
        
        backTouchableView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 20 - buttonMargin))
            $0.top.equalToSuperview().inset(moderateScale(number: 16 - buttonMargin))
            $0.size.equalTo(moderateScale(number: buttonMargin + 24 + buttonMargin))
        }
        
        backImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        closeTouchableView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(moderateScale(number: 20 - buttonMargin))
            $0.top.equalToSuperview().inset(moderateScale(number: 16 - buttonMargin))
            $0.size.equalTo(moderateScale(number: buttonMargin + 24 + buttonMargin))
        }
        
        closeImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
    }
}
