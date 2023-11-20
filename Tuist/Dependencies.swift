//
//  Dependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/22.
//

import ProjectDescription

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: [
            .alamofire,
            .snapKit,
            .then,
            .swinject,
            .kakaoSDK
    ],
    platforms: [.iOS]
)

public extension Package {
    static let alamofire: Package = .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .branch("master"))
    static let snapKit: Package = .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMajor(from: "5.0.1"))
    static let then: Package = .remote(url: "https://github.com/devxoul/Then", requirement: .upToNextMajor(from: "2.7.0"))
    static let swinject: Package = .remote(url: "https://github.com/Swinject/Swinject", requirement: .upToNextMajor(from: "2.8.3"))
    static let kakaoSDK: Package = .remote(url: "https://github.com/kakao/kakao-ios-sdk", requirement: .upToNextMajor(from: "2.0.0"))
}
