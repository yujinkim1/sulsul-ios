//
//  SignInViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2023-11-20.
//

import Alamofire
import AuthenticationServices
import Combine
import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import Service

final class SignInViewModel: NSObject {
    override public init() {
        super.init()
    }
    
    public func continueWithApple() {
        signin(type: .apple)
    }

    public func continueWithKakao() {
        signin(type: .kakao)
    }

    public func continueWithGoogle() {
        signin(type: .google)
    }
}

// MARK: - SignInType

extension SignInViewModel {
    enum SignInType {
        case apple, google, kakao
        
        func endpoint() -> String {
            switch self {
            case .apple: return "auth/sign-in/apple"
            case .google: return "auth/sign-in/google"
            case .kakao: return "auth/sign-in/kakao"
            }
        }
    }
    
    private func signin(type: SignInType) {
        switch type {
        case .apple:
            appleAuthenticationAdapter()
        case .google:
            googleAuthenticationAdapter()
        case .kakao:
            kakaoAuthenticationAdapter()
        }
    }
}

// MARK: - Authentication

extension SignInViewModel {
    private func appleAuthenticationAdapter() {
        let authorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
        
        let request = authorizationAppleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    private func googleAuthenticationAdapter() {
        // GoogleSignIn 패키지 오류 해결 이후 적용
    }
    
    private func kakaoAuthenticationAdapter() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                guard error != nil else { return }
                
                if let accessToken = oauthToken?.accessToken {
                    let url = SignInType.kakao.endpoint()
                    let parameters: Parameters = ["access_token": accessToken]
                    NetworkWrapper.shared.postBasicTask(stringURL: url, parameters: parameters) { result in
                        switch result {
                        case .success(let responseData):
                            print(responseData)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        }
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
            guard error != nil else { return }
            
            if let accessToken = oauthToken?.accessToken {
                let url = SignInType.kakao.endpoint()
                let parameters: Parameters = ["access_token": accessToken]
                NetworkWrapper.shared.postBasicTask(stringURL: url, parameters: parameters) { result in
                    switch result {
                    case .success(let responseData):
                        print(responseData)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}

// MARK: - Authentication Services 델리게이트

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
