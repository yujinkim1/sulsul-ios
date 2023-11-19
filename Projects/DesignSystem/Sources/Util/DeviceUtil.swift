//
//  DeviceUtil.swift
//  DesignSystem
//
//  Created by 이범준 on 11/19/23.
//

import Foundation
import Alamofire

final class DeviceUtil {
    static let shared = DeviceUtil()
    
    private init() {}
    
    func isNetworkConnected() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func languageCode() -> String {
        if #available(iOS 16, *) {
            return Locale.current.language.languageCode?.identifier ?? "en"
        } else {
            return NSLocale.current.languageCode ?? "en"
        }
    }
}

