//
//  DeviceUtil.swift
//  DesignSystem
//
//  Created by 이범준 on 11/19/23.
//

import Foundation
import Alamofire

public final class DeviceUtil {
    static let shared = DeviceUtil()
    
    private init() {}
    
    public func isNetworkConnected() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    public func languageCode() -> String {
        if #available(iOS 16, *) {
            return Locale.current.language.languageCode?.identifier ?? "en"
        } else {
            return NSLocale.current.languageCode ?? "en"
        }
    }
}

