//
//  SignInViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2023-11-20.
//

import KakaoSDKAuth
import KakaoSDKUser

import AuthenticationServices
import Foundation

public class SignInViewModel: NSObject {
    override public init() {
        super.init()
    }

    public func continueWithKakaoDidTap() {
        kakaoAuthentication()
    }

    public func continueWithGoogleDidTap() {}

    public func continueWithAppleDidTap() {
        let authorizationAppleIDProvider = ASAuthorizationAppleIDProvider()

        let request = authorizationAppleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension SignInViewModel {
    private func kakaoAuthentication() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("kakaoAuthentication(): 카카오톡 로그인 성공")
                    _ = oauthToken
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("kakaoAuthentication(): 카카오톡 로그인 성공")
                    let token = oauthToken
                    let accessToken = token?.accessToken
                    let refreshToken = token?.refreshToken
                    let expiresIn = token?.expiresIn

                    print("Access Token: \(String(describing: accessToken))")
                    print("Refresh Token: \(String(describing: refreshToken))")
                    print("Expires In: \(String(describing: expiresIn))")
                }
            }
        }
    }
}

extension SignInViewModel: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = credential.user
            let fullName = credential.fullName
            let email = credential.email

            print("User Identifier: \(userIdentifier)")
            print("Full Name: \(fullName?.givenName ?? "nil") \(fullName?.familyName ?? "nil")")
            print("Email: \(email ?? "nil")")
            if let token = credential.identityToken,
               let tokenToString = String(data: token, encoding: .utf8) {
                print("token: \(tokenToString)")
            }
        }
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple 실패: \(error.localizedDescription)")
    }
}
