//
//  UserName.swift
//  Feature
//
//  Created by Yujin Kim on 2023-12-17.
//

import Foundation

struct UserName: Equatable {
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case value = "nickname"
    }
}
