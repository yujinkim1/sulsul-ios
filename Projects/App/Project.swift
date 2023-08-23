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
                            Module.feature,
                          ].map(\.project),
                          infoPlist: .file(path: "Support/Info.plist"),
                          sources: .default,
                          resources: .default)
