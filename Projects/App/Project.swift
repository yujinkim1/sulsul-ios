//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/22.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(name: Module.app.name,
                          dependencies: [
                            Module.designSystem,
                          ].map(\.project),
                          resources: .default)
