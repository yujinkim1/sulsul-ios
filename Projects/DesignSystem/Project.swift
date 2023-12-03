//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/22.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(name: Module.designSystem.name,
                                packages: [.remote(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git",
                                            requirement: .upToNextMajor(from: "3.8.0"))
                                ],
                                dependencies: [Module.thirdParty.project,
                                               .package(product: "CocoaLumberjack"),
                                               .package(product: "CocoaLumberjackSwift")],
                                sources: .default,
                                resources: .default)
