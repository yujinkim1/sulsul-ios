//
//  ProjectName.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/22.
//

import ProjectDescription

public enum Module {
    // 실행 App
    case app
    // DesignSystem
    case designSystem
}

extension Module {
    
    public var name: String {
        switch self {
        case .app:
            return "App"
        case .designSystem:
            return "DesignSystem"
        }
    }
    
    public var path: ProjectDescription.Path {
        return .relativeToRoot("Projects/" + self.name)
    }
    
    public var project: TargetDependency {
        return .project(target: self.name, path: self.path)
    }
}

extension Module: CaseIterable { }
