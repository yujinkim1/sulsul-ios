//
//  SignInViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2023-11-20.
//

import DesignSystem
import SnapKit
import Then

import UIKit

public class SignInViewController: BaseViewController {

    private lazy var topContainerView = UIView()

    private lazy var titleLabel = UILabel().then({
        $0.numberOfLines = 2
        $0.textColor = .white
        // $0.font = .setFont(size: 32, family: .Bold)
        $0.font = .boldSystemFont(ofSize: 32)
        $0.text = "만나서\n반가워요! :)"
    })

    private lazy var middleContainerView = UIView()

    private lazy var kakaoImage = UIImageView().then({
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "continue_with_kakao")
    })

    private lazy var googleImage = UIImageView().then({
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "continue_with_google")
    })

    private lazy var appleImage = UIImageView().then({
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "continue_with_apple")
    })

    private lazy var continueWithKakao = TouchableView().then({
        $0.addSubview(kakaoImage)
    })

    private lazy var continueWithGoogle = TouchableView().then({
        $0.addSubview(googleImage)
    })

    private lazy var continueWithApple = TouchableView().then({
        $0.addSubview(appleImage)
    })

    override public func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        makeConstraints()
        setupIfNeeded()
        view.backgroundColor = UIColor(r: 32, g: 32, b: 32, alpha: 1)
    }

    override public func addViews() {
        view.addSubviews([topContainerView, middleContainerView])
        topContainerView.addSubview(titleLabel)
        middleContainerView.addSubviews([continueWithKakao, continueWithGoogle, continueWithApple])
    }

    override public func makeConstraints() {
        topContainerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 152))
        }
        middleContainerView.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom).offset(moderateScale(number: 170))
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
            $0.top.equalTo(continueWithKakao.snp.bottom).offset(moderateScale(number: 12))
            $0.centerX.equalTo(continueWithKakao)
            $0.width.equalTo(continueWithKakao)
            $0.height.equalTo(continueWithKakao)
        }
        googleImage.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        continueWithApple.snp.makeConstraints {
            $0.top.equalTo(continueWithGoogle.snp.bottom).offset(moderateScale(number: 12))
            $0.centerX.equalTo(continueWithGoogle)
            $0.width.equalTo(continueWithGoogle)
            $0.height.equalTo(continueWithGoogle)
        }
        appleImage.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
    }

    override public func setupIfNeeded() {
        continueWithKakao.setOpaqueTapGestureRecognizer {
            print("카카오 로그인 버튼 탭")
        }
        continueWithGoogle.setOpaqueTapGestureRecognizer {
            print("구글 로그인 버튼 탭")
        }
        continueWithApple.setOpaqueTapGestureRecognizer {
            print("애플 로그인 버튼 탭")
        }
    }

}

