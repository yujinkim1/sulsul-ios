//
//  AuthViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2023-11-20.
//

import Alamofire
import AuthenticationServices
import Foundation
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser
import Service
import Combine

enum UserSettingType {
    case initSettingUser
    case nickNameSettingUser
    case drinkSettingUser
    case allSettingUSer
}

final class AuthViewModel: NSObject {
    
    private lazy var jsonDecoder = JSONDecoder()
    private let userMapper = UserMapper()
//    private var userSettingType: UserSettingType = .initSettingUser
    
    private let errorSubject = CurrentValueSubject<String, Never>("")
    private let userSettingType = PassthroughSubject<UserSettingType, Never>()
    private let loginSuccess = PassthroughSubject<Void, Never>()
    
    override public init() {
        super.init()
    }
    
    public func continueWithApple() {
        signin(type: .apple)
    }

    public func continueWithKakao() {
        signin(type: .kakao)
    }

    public func continueWithGoogle(id: String, item: String) {
        signin(type: .google, id: id, item: item)
    }
    
// TODO: 로그인하고 response 값으로 status에 banned이면 영구정지 사용자임 앱 못들어가게 막아야됨
    func getUserInfo(userId: Int) {
        NetworkWrapper.shared.getBasicTask(stringURL: "/users/\(UserDefaultsUtil.shared.getInstallationId())") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if let userInfo = try? self.jsonDecoder.decode(RemoteUserInfoItem.self, from: response) {
                    let mappedUserInfo = self.userMapper.userInfoModel(from: userInfo)
                    print("내정보: \(mappedUserInfo)")
                    if mappedUserInfo.nickname.isEmpty {
                        userSettingType.send(.initSettingUser)
                    } else if mappedUserInfo.preference.alcohols == [0] {
                        userSettingType.send(.nickNameSettingUser)
                    } else if mappedUserInfo.preference.foods == [0] {
                        userSettingType.send(.drinkSettingUser)
                    } else {
                        userSettingType.send(.allSettingUSer)
                        print(">>>>> 키체인 잘저장되나 :\(KeychainStore.shared.read(label: "accessToken"))")
                    }
                } else {
                    print("디코딩 에러")
                }
            case .failure(let error):
                errorSubject.send(error.localizedDescription)
            }
        }
    }
    
    func getErrorSubject() -> AnyPublisher<String, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    func userSettingTypePublisher() -> AnyPublisher<UserSettingType, Never> {
        return userSettingType.eraseToAnyPublisher()
    }
}

// MARK: - SignInType

extension AuthViewModel {
    enum SignInType {
        case apple, google, kakao
        
        func endpoint() -> String {
            switch self {
            case .apple: return "/auth/sign-in/apple"
            case .google: return "/auth/sign-in/google"
            case .kakao: return "/auth/sign-in/kakao"
            }
        }
    }
    
    private func signin(type: SignInType, id: String = "", item: String = "") {
        switch type {
        case .apple:
            appleAuthenticationAdapter()
        case .google:
            googleAuthenticationAdapter(id: id, item: item)
        case .kakao:
            kakaoAuthenticationAdapter()
        }
    }
}

// MARK: - Authentication

extension AuthViewModel {
    private func appleAuthenticationAdapter() {
        let authorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
        
        let request = authorizationAppleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    private func googleAuthenticationAdapter(id: String, item: String) {
        let url = SignInType.google.endpoint()
        let parameters: Parameters = [
            "google_client_id": id,
            "id_token": item
        ]
        
        NetworkWrapper.shared.postBasicTask(stringURL: url, parameters: parameters) { result in
            switch result {
            case .success(let responseData):
                if let data = try? self.jsonDecoder.decode(Token.self, from: responseData) {
                    let accessToken = data.accessToken
                    let tokenType = data.tokenType
                    let expiresIn = data.expiresIn
                    let id = data.userID
                    
                    KeychainStore.shared.create(item: accessToken, label: "accessToken")
                    print("로그인된 구글 아이디: \(id)")
                    UserDefaultsUtil.shared.setUserId(id)
                    self.getUserInfo(userId: id)
                } else {
                    print("디코딩 모델 에러1")
                }
            case .failure(let error):
                if let networkError = error as? NetworkError {
                    self.errorSubject.send(networkError.getErrorMessage() ?? "알 수 없는 에러")
                }
            }
        }
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
                            if let data = try? self.jsonDecoder.decode(Token.self, from: responseData) {
                                let accessToken = data.accessToken
                                let tokenType = data.tokenType
                                let expiresIn = data.expiresIn
                                let id = data.userID
                                
                                print(">>>>카카오 아이디")
                                print(id)
                                UserDefaultsUtil.shared.setUserId(id)
                                KeychainStore.shared.create(item: accessToken, label: "accessToken")
                                self.getUserInfo(userId: id)
                            } else {
                                print("디코딩 모델 에러2")
                            }
                        case .failure(let error):
                            if let networkError = error as? NetworkError {
                                self.errorSubject.send(networkError.getErrorMessage() ?? "알 수 없는 에러")
                            }
                        }
                    }
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                guard error == nil else { return }
                
                if let accessToken = oauthToken?.accessToken {
                    let url = SignInType.kakao.endpoint()
                    let parameters: Parameters = ["access_token": accessToken]
                    NetworkWrapper.shared.postBasicTask(stringURL: url, parameters: parameters) { result in
                        switch result {
                        case .success(let responseData):
                            if let data = try? self.jsonDecoder.decode(Token.self, from: responseData) {
                                let accessToken = data.accessToken
                                let tokenType = data.tokenType
                                let expiresIn = data.expiresIn
                                let id = data.userID
                                
                                UserDefaultsUtil.shared.setUserId(id)
                                KeychainStore.shared.create(item: accessToken, label: "accessToken")
                                self.getUserInfo(userId: id)
                            } else {
                                print("디코딩 모델 에러3")
                            }
                        case .failure(let error):
                            if let networkError = error as? NetworkError {
                                self.errorSubject.send(networkError.getErrorMessage() ?? "알 수 없는 에러")
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Apple Authentication Services 델리게이트

extension AuthViewModel: ASAuthorizationControllerDelegate {
    internal func authorizationController(controller: ASAuthorizationController,
                                          didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = credential.identityToken,
              let idToken = String(data: identityToken, encoding: .utf8) else { return }
        
        let url = SignInType.apple.endpoint()
        let parameters: Parameters = ["id_token": idToken]
        NetworkWrapper.shared.postBasicTask(stringURL: url, parameters: parameters) { result in
            switch result {
            case .success(let responseData):
                if let data = try? self.jsonDecoder.decode(Token.self, from: responseData) {
                    let accessToken = data.accessToken
                    let tokenType = data.tokenType
                    let expiresIn = data.expiresIn
                    let id = data.userID
                    
                    KeychainStore.shared.create(item: accessToken, label: "accessToken")
                    print("로그인된 애플 아이디: \(id)")
                    UserDefaultsUtil.shared.setUserId(id)
                    self.getUserInfo(userId: id)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    internal func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("[!] Authorization Services: \(error.localizedDescription)")
    }
}
