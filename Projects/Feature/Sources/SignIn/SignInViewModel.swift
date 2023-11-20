//
//  SignInViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2023-11-20.
//

import KakaoSDKAuth
import KakaoSDKUser

import Foundation

public class SignInViewModel {
    public func continueWithKakaoDidTap() {
        kakaoAuthentication()
    }

    public func continueWithGoogleDidTap() {}

    public func continueWithAppleDidTap() {}
}

extension SignInViewModel {
    private func kakaoAuthentication() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("prepareToKakaoAuthentication(): 카카오톡 로그인 성공")
                    _ = oauthToken
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoAccount() success.")
                    _ = oauthToken
                }
            }
        }
    }
}
