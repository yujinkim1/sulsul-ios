//
//  SelectUserNameViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2023-12-17.
//

import DesignSystem
import Combine
import UIKit

public enum SelectUserNameViewState {
    case normal, random, direct
}

public final class SetUserNameViewController: BaseViewController {
//    var viewModel: SelectUserNameViewModel?
//    
//    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var topHeaderView = UIView()
    
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "left_arrow"), for: .normal)
        $0.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var induceUserNameLabel = UILabel().then {
        $0.font = Font.bold(size: 18)
        $0.text = "어떤 닉네임을 사용할까요?"
        $0.textColor = DesignSystemAsset.white.color
    }
    
    private lazy var userNameTextField = UITextField().then {
        $0.clearButtonMode = .always
        $0.font = Font.bold(size: 32)
        $0.tintColor = DesignSystemAsset.white.color
        $0.placeholder = "닉네임을 입력해주세요."
    }
    
    private lazy var randomButton = UIButton().then {
        var attributeContainer = AttributeContainer()
        attributeContainer.font = Font.bold(size: 16)
        
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = .clear
        configuration.attributedTitle = AttributedString("랜덤 닉네임 쓸래요!", attributes: attributeContainer)
        
        $0.configuration = configuration
        $0.contentMode = .center
        $0.isEnabled = true
    }
    
    private lazy var directButton = UIButton().then {
        $0.setTitle("다른거 할래요", for: .normal)
    }
    
    private lazy var nextButton = UIButton().then {
        $0.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        $0.backgroundColor = DesignSystemAsset.gray300.color
        $0.titleLabel?.font = Font.bold(size: 16)
        $0.titleLabel?.textColor = .white
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.setTitle("다음", for: .normal)
    }
    
    public override func viewDidLoad() {
//        viewModel = SelectUserNameViewModel()
        
        view.backgroundColor = DesignSystemAsset.black.color
        overrideUserInterfaceStyle = .dark
        
        addViews()
        makeConstraints()
    }
    
    public override func addViews() {
        topHeaderView.addSubviews([backButton, induceUserNameLabel])
        view.addSubviews([topHeaderView, userNameTextField, randomButton, nextButton])
    }
    
    public override func makeConstraints() {
        topHeaderView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(moderateScale(number: 59))
        }
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
        induceUserNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(backButton.snp.bottom).offset(16)
        }
        userNameTextField.snp.makeConstraints {
            $0.leading.equalTo(topHeaderView)
            $0.top.equalTo(topHeaderView.snp.bottom).offset(12)
        }
        nextButton.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 50))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - Custom method

extension SetUserNameViewController {}

// MARK: - @objc

extension SetUserNameViewController {
    @objc private func backButtonDidTap() {}
    
    @objc private func nextButtonDidTap() {}
}
