//
//  Environment+Project.swift
//  SulSulIOS
//
//  Created by Yujin Kim on 2024-06-07.
//

import ProjectDescription

public extension Project {
    enum Environment {
        public static let platform: [ProjectDescription.Platform] = [
            .iOS
        ]
        public static let destinations: Set<ProjectDescription.Destination> = [
            .iPhone,
            .iPad
        ]
        public static let deploymentTargets: [ProjectDescription.DeploymentTargets] = [
            .iOS("15.0")
        ]
        public static let bundleIdentifierPrefix: String = "com.SulSul-iOS"
    }
}
