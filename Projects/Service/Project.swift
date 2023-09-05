//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/23.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(name: Module.service.name,
                                dependencies: [Module.thirdParty.project],
                                sources: .default)
