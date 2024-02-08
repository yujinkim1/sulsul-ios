//
//  UserDefaultsUtil.swift
//  Service
//
//  Created by 이범준 on 2024/01/29.
//

import Foundation

public struct UserDefaultsUtil {
    public static let shared = UserDefaultsUtil()
    
    private init() {}
    
    private let defaults = UserDefaults.standard
    
    public enum UserDefaultKey: String {
        case userId
        case recentKeyword
    }
    
    public func setRecentKeywordList(_ dataList: [String]) {
        defaults.setValue(dataList, forKey: UserDefaultKey.recentKeyword.rawValue)
    }
    
    public func recentKeywordList() -> [String]? {
        return defaults.value(forKey: UserDefaultKey.recentKeyword.rawValue) as? [String]
    }
    
    public func setUserId(_ id: Int) {
        defaults.setValue(id, forKey: UserDefaultKey.userId.rawValue)
    }
    
    public func getInstallationId() -> Int {
        return defaults.value(forKey: UserDefaultKey.userId.rawValue) as? Int ?? 0
    }
    
    public func remove(_ key: UserDefaultKey) {
        defaults.removeObject(forKey: key.rawValue)
    }
}
