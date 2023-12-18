//
//  SnackModel.swift
//  Feature
//
//  Created by 김유진 on 2023/12/17.
//

import Foundation

struct SnackModel {
    var id: Int
    var type: String
    var subtype: String
    var name: String
    var image: String
    var description: String
    var isSelect: Bool
    var highlightedText: String
}

struct SnackSectionModel {
    var cellModels: [SnackModel]
    var headerModel: SnackHeader
}

struct SnackHeader {
    let snackHeaderTitle: String
    let snackHeaderImage: String
}
