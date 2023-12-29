//
//  SetUserNameViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2023-12-17.
//

import Combine
import UIKit
import DesignSystem

// defaultStackView

public final class SetUserNameViewController: BaseViewController {
    
    private var viewModel: SelectUserNameViewModel?
    private var cancelBag = Set<AnyCancellable>()
    
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
        $0.delegate = self
        $0.font = Font.bold(size: 32)
        $0.tintColor = DesignSystemAsset.white.color
        $0.placeholder = "닉네임을 입력해주세요."
    }
    
    private lazy var defaultStackView = ValidationLabelStackView().then {
        $0.axis = .horizontal
        $0.spacing = CGFloat(6)
    }
    
    private lazy var specialCharactersStackView = ValidationLabelStackView().then {
        $0.axis = .horizontal
        $0.spacing = CGFloat(6)
        $0.isHidden = true
    }
    
    private lazy var lessThanCharactersStackView = ValidationLabelStackView().then {
        $0.axis = .horizontal
        $0.spacing = CGFloat(6)
        $0.isHidden = true
    }
    
    private lazy var randomButton = UIButton().then {
        var attributeContainer = AttributeContainer()
        attributeContainer.font = Font.bold(size: 16)
        
        var configuration = UIButton.Configuration.plain()
        configuration.background.backgroundColor = .clear
        configuration.attributedTitle = AttributedString("랜덤 닉네임 쓸래요!", attributes: attributeContainer)
        
        $0.configuration = configuration
        $0.contentMode = .center
        $0.isHidden = true
        $0.tintColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var generateButton = UIButton().then {
        $0.addTarget(self, action: #selector(generateButtonDidTap), for: .touchUpInside)
        $0.backgroundColor = DesignSystemAsset.gray300.color
        $0.titleLabel?.font = Font.bold(size: 16)
        $0.titleLabel?.textColor = DesignSystemAsset.gray700.color
        $0.layer.cornerRadius = CGFloat(8)
        $0.setTitle("다른거 할래요", for: .normal)
    }
    
    private lazy var nextButton = UIButton().then {
        $0.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        $0.backgroundColor = DesignSystemAsset.gray300.color
        $0.titleLabel?.font = Font.bold(size: 16)
        $0.titleLabel?.textColor = .white
        $0.layer.cornerRadius = CGFloat(12)
        $0.setTitle("다음", for: .normal)
        $0.isEnabled = false
    }
    
    public override func viewDidLoad() {
        view.backgroundColor = DesignSystemAsset.black.color
        overrideUserInterfaceStyle = .dark
        
        viewModel = SelectUserNameViewModel()
        
        addViews()
        makeConstraints()
        
        bind()
        
        viewModel?.requestRandomNickname()
    }
    
    public override func addViews() {
        topHeaderView.addSubviews([backButton, induceUserNameLabel])
        view.addSubviews([
            topHeaderView,
            userNameTextField,
            defaultStackView,
            specialCharactersStackView,
            lessThanCharactersStackView,
            generateButton,
            randomButton,
            nextButton
        ])
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
            $0.top.equalTo(backButton.snp.bottom).offset(moderateScale(number: 16))
        }
        userNameTextField.snp.makeConstraints {
            $0.leading.trailing.equalTo(topHeaderView)
            $0.top.equalTo(topHeaderView.snp.bottom).offset(moderateScale(number: 28))
        }
        defaultStackView.snp.makeConstraints {
            $0.leading.equalTo(userNameTextField)
            $0.top.equalTo(userNameTextField.snp.bottom).offset(8)
        }
        specialCharactersStackView.snp.makeConstraints {
            $0.leading.equalTo(userNameTextField)
            $0.top.equalTo(userNameTextField.snp.bottom).offset(8)
        }
        lessThanCharactersStackView.snp.makeConstraints {
            $0.leading.equalTo(specialCharactersStackView)
            $0.top.equalTo(specialCharactersStackView.snp.bottom).offset(8)
        }
        generateButton.snp.makeConstraints {
            $0.trailing.equalTo(userNameTextField)
            $0.top.equalTo(defaultStackView.snp.bottom).offset(16)
            $0.width.equalTo(moderateScale(number: 135))
            $0.height.equalTo(moderateScale(number: 40))
        }
        randomButton.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top).offset(-24)
            $0.centerX.equalTo(nextButton)
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(topHeaderView)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(moderateScale(number: 50))
        }
    }
}

extension SetUserNameViewController: UITextFieldDelegate {
//    public func textFieldDidEndEditing(_ textField: UITextField) {
//        updateValidationLabelStackView(text: textField.text)
//    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        updateValidationLabelStackView(text: textField.text)
        return true
    }
    
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else { return true }
        
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        updateValidationLabelStackView(text: newText)
        return true
    }
}

// MARK: - Custom method

extension SetUserNameViewController {
    
    private func bind() {
        viewModel?.userNamePublisher()
            .sink { [weak self] userName in
                self?.userNameTextField.text = userName
            }
            .store(in: &cancelBag)
    }
    
    private func updateValidationLabelStackView(text: String?) {
        guard let userName = text else { return }
        
        let randomNickname = viewModel?.userName ?? ""
        let specialCharacterRegex = ".*[!@#$%^&*()-_+=\"<:>'].*"
        let hasSpecialCharacter = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegex).evaluate(with: userName)
        let isEnoughLength = userName.count > 0 && userName.count < 10
        
        if userName.count == 0 {
            specialCharactersStackView.configure(to: .common, "특수문자 사용은 안돼요.")
            lessThanCharactersStackView.configure(to: .common, "한글/영문, 숫자 포함 10자로 사용 가능해요.")
            
            specialCharactersStackView.isHidden = false
            lessThanCharactersStackView.isHidden = false
            generateButton.isHidden = true
            randomButton.isHidden = true
        }
        
        if userName == randomNickname {
            specialCharactersStackView.isHidden = true
            lessThanCharactersStackView.isHidden = true
            generateButton.isHidden = true
        } else {
            if userName.count == 0 {
                specialCharactersStackView.configure(to: .common, "특수문자 사용은 안돼요.")
                lessThanCharactersStackView.configure(to: .common, "한글/영문, 숫자 포함 10자로 사용 가능해요.")
                
                specialCharactersStackView.isHidden = false
                lessThanCharactersStackView.isHidden = false
                randomButton.isHidden = true
            } else {
                if userName.count >= 10 && hasSpecialCharacter {
                    specialCharactersStackView.configure(to: .nonpass, "특수문자가 포함되어 있어요.")
                    lessThanCharactersStackView.configure(to: .nonpass, "한글/영문, 숫자 포함 1~10자 이내로 설정해주세요.")
                    
                    defaultStackView.isHidden = true
                    specialCharactersStackView.isHidden = false
                    lessThanCharactersStackView.isHidden = false
                    generateButton.isHidden = false
                    randomButton.isHidden = true
                } else {
                    specialCharactersStackView.configure(
                        to: !hasSpecialCharacter ? .pass : .nonpass,
                        !hasSpecialCharacter ? "입력된 특수문자가 없어요." : "특수문자가 포함되어 있어요."
                    )
                    lessThanCharactersStackView.configure(
                        to: isEnoughLength ? .pass : .nonpass,
                        isEnoughLength ? "적절한 글자수의 닉네임이에요." : "한글/영문, 숫자 포함 1~10자 이내로 설정해주세요."
                    )
                    
                    defaultStackView.isHidden = true
                    specialCharactersStackView.isHidden = false
                    lessThanCharactersStackView.isHidden = false
                    generateButton.isHidden = false
                    randomButton.isHidden = true
                }
            }
        }
        
        updateNextButton(userNameText: userName, randomUserName: randomNickname)
    }
    
    private func updateNextButton(userNameText: String?, randomUserName: String?) {
        if let userNameText = userNameText, !userNameText.isEmpty,
           let randomUserName = randomUserName, !randomUserName.isEmpty {
            nextButton.isEnabled = true
            
            let yellowColor = UIColor(red: 255/255, green: 182/255, blue: 2/255, alpha: 1)
            nextButton.backgroundColor = yellowColor
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = DesignSystemAsset.gray300.color
        }
    }
}

// MARK: - @objc

extension SetUserNameViewController {
    @objc private func backButtonDidTap() {}
    
    @objc private func generateButtonDidTap() {
        viewModel?.requestRandomNickname()
    }
    
    @objc private func nextButtonDidTap() {}
}
