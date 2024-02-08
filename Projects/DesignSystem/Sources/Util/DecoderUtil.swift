//
//  DecoderUtil.swift
//  DesignSystem
//
//  Created by 이범준 on 11/19/23.
//

import Foundation

public struct DecoderUtil {
    static private let decoder = JSONDecoder()
    
    static func decode<T: Codable>(_ type: T.Type, data: Data) -> T? {
        return try? decoder.decode(type, from: data)
    }
}
