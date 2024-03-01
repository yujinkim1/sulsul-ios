//
//  InfoEditView.swift
//  Feature
//
//  Created by 김유진 on 3/1/24.
//

import UIKit
import DesignSystem

final class InfoEditView: UIView {
    private lazy var containerView = UIView().then {
        $0.layer.cornerRadius = moderateScale(number: 24)
        $0.backgroundColor = DesignSystemAsset.gray100.color
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "인식된 술&안주 정보 수정"
        $0.font = Font.bold(size: 20)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var drinkLabel = UILabel().then {
        $0.text = "술"
        $0.font = Font.bold(size: 16)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var drinkTextFieldView = UIView().then {
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.layer.borderColor = DesignSystemAsset.gray100.color.cgColor
        $0.layer.borderWidth = moderateScale(number: 1)
    }
    
    private lazy var drinkTextField = UITextField().then {
        $0.placeholder = "술을 입력해주세요."
        $0.font = Font.semiBold(size: 16)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var snackLabel = UILabel().then {
        $0.text = "안주"
        $0.font = Font.bold(size: 16)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var snackTextFieldView = UIView().then {
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.layer.borderColor = DesignSystemAsset.gray100.color.cgColor
        $0.layer.borderWidth = moderateScale(number: 1)
    }
    
    private lazy var snackTextField = UITextField().then {
        $0.placeholder = "안주를 입력해주세요."
        $0.font = Font.semiBold(size: 16)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var completeButton = DefaultButton(title: "수정 완료!").then {
        $0.setClickable(false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        attributes()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InfoEditView {
    private func attributes() {
        overrideUserInterfaceStyle = .dark
        backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    private func layout() {
        addSubview(containerView)
        
        containerView.addSubviews([
            titleLabel,
            drinkLabel,
            drinkTextFieldView,
            snackLabel,
            snackTextFieldView,
            completeButton
        ])
        
        drinkTextFieldView.addSubview(drinkTextField)
        snackTextFieldView.addSubview(snackTextField)
        
        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(moderateScale(number: 353))
            $0.height.equalTo(moderateScale(number: 348))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        drinkLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 24))
        }
        
        drinkTextFieldView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalTo(drinkLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 48))
        }
        
        drinkTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 12))
            $0.centerY.equalToSuperview()
        }
        
        snackLabel.snp.makeConstraints {
            $0.top.equalTo(drinkTextFieldView.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.equalTo(drinkLabel)
        }
        
        snackTextFieldView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalTo(snackLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 48))
        }
        
        snackTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 12))
            $0.centerY.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 52))
        }
    }
}
