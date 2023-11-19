//
//  CommonUtil.swift
//  DesignSystem
//
//  Created by 이범준 on 11/19/23.
//

import UIKit

public final class CommonUtil {
    static let shared = CommonUtil()
    
    private init() {}
    
    public enum AppStore: String {
        // TODO: appStore 주소
        case appStore = ""
    }
    
    public func versionCode() -> String {
        if let info = Bundle.main.infoDictionary,
           let version = info["CFBundleShortVersionString"] as? String {
            return version
        }
        return ""
    }
    
    public func updateApp() {
        if let url = URL(string: AppStore.appStore.rawValue), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
