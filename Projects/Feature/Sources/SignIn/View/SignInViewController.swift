//
//  SignInViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2023-11-20.
//

import DesignSystem
import GoogleSignIn
import UIKit

public class SignInViewController: BaseViewController {
    var viewModel: SignInViewModel?

    private lazy var topContainerView = UIView()

    private lazy var titleLabel = UILabel().then {
        $0.font = Font.bold(size: 32)
        $0.numberOfLines = 2
        $0.textColor = .white
        $0.text = "만나서\n반가워요! :)"
    }

    private lazy var middleContainerView = UIView()

    private lazy var kakaoImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "continue_with_kakao")
    }

    private lazy var googleImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "continue_with_google")
    }

    private lazy var appleImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "continue_with_apple")
    }

    private lazy var continueWithKakao = TouchableView().then {
        $0.addSubview(kakaoImage)
    }

    private lazy var continueWithGoogle = TouchableView().then {
        $0.addSubview(googleImage)
    }

    private lazy var continueWithApple = TouchableView().then {
        $0.addSubview(appleImage)
    }
    
    private lazy var termsButton = UIButton().then {
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.numberOfLines = 2
        $0.titleLabel?.font = Font.medium(size: 14)
        
        let attributedText = NSMutableAttributedString(string: "가입을 진행할 경우, 서비스 약관 및\n개인정보 처리방침에 동의한 것으로 간주합니다.")

        attributedText.addAttribute(.font, value: Font.bold(size: 14), range: NSRange(location: 12, length: 6))
        attributedText.addAttribute(.foregroundColor, value: DesignSystemAsset.gray800.color, range: NSRange(location: 12, length: 6))
        
        attributedText.addAttribute(.font, value: Font.bold(size: 14), range: NSRange(location: 21, length: 9))
        attributedText.addAttribute(.foregroundColor, value: DesignSystemAsset.gray800.color, range: NSRange(location: 21, length: 9))
        
        let otherTextRange = NSRange(location: 0, length: attributedText.length)
        attributedText.addAttribute(.foregroundColor, value: DesignSystemAsset.gray500.color, range: otherTextRange)
        
        $0.setAttributedTitle(attributedText, for: .normal)
        $0.addTarget(self, action: #selector(termsButtonDidTap(_:)), for: .touchUpInside)
    }

    override public func viewDidLoad() {
        
        view.backgroundColor = DesignSystemAsset.black.color
        overrideUserInterfaceStyle = .dark
        
        viewModel = SignInViewModel()
        
        addViews()
        makeConstraints()
        setupIfNeeded()
    }

    override public func addViews() {
        view.addSubviews([topContainerView, middleContainerView, termsButton])
        topContainerView.addSubview(titleLabel)
        middleContainerView.addSubviews([continueWithKakao, continueWithGoogle, continueWithApple])
    }

    override public func makeConstraints() {
        topContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(moderateScale(number: 32))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 152))
        }
        middleContainerView.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom).offset(moderateScale(number: 239))
            $0.leading.equalToSuperview().offset(moderateScale(number: 20))
            $0.trailing.equalToSuperview().offset(moderateScale(number: -20))
            $0.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: 20))
            $0.bottom.equalToSuperview().offset(moderateScale(number: -20))
        }
        continueWithKakao.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(280)
            $0.height.equalTo(48)
        }
        kakaoImage.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        continueWithGoogle.snp.makeConstraints {
            $0.top.equalTo(continueWithKakao.snp.bottom).offset(moderateScale(number: 16))
            $0.centerX.equalTo(continueWithKakao)
            $0.width.equalTo(continueWithKakao)
            $0.height.equalTo(continueWithKakao)
        }
        googleImage.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        continueWithApple.snp.makeConstraints {
            $0.top.equalTo(continueWithGoogle.snp.bottom).offset(moderateScale(number: 16))
            $0.centerX.equalTo(continueWithGoogle)
            $0.width.equalTo(continueWithGoogle)
            $0.height.equalTo(continueWithGoogle)
        }
        appleImage.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        termsButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(moderateScale(number: -8))
        }
    }

    override public func setupIfNeeded() {
        continueWithKakao.setOpaqueTapGestureRecognizer { [weak self] in
            self?.viewModel?.continueWithKakao()
        }
        
        continueWithGoogle.setOpaqueTapGestureRecognizer { [weak self] in
            let id = "78471557734-vab1c2tk22mhkal1gg5v32p97qb1a0ra.apps.googleusercontent.com"
            let configuration = GIDConfiguration(clientID: id)
            GIDSignIn.sharedInstance.configuration = configuration
            
            GIDSignIn.sharedInstance.signIn(withPresenting: self!) { [weak self] signInResult, _ in
                guard let self,
                      let result = signInResult,
                      let token = result.user.idToken?.tokenString else { return }
                self.viewModel?.continueWithGoogle(id: id, item: token)
            }
            
        }
        
        continueWithApple.setOpaqueTapGestureRecognizer { [weak self] in
            self?.viewModel?.continueWithApple()
        }
    }

}

// MARK: - @objc

extension SignInViewController {
    @objc private func termsButtonDidTap(_ button: UIButton) {}
}
