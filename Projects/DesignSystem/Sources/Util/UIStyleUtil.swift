//
//  UIStyleUtil.swift
//  DesignSystem
//
//  Created by 이범준 on 11/19/23.
//

import UIKit

public final class UIStyleUtil {
    static let shared = UIStyleUtil()
    
    private init() {}
    
    func currentUserInterfaceStyle() -> UIUserInterfaceStyle? {
        if let window = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if #available(iOS 15.0, *) {
                return window.windows.first?.traitCollection.userInterfaceStyle
            }
        } else if let window = UIApplication.shared.windows.first {
            if #available(iOS 13.0, *) {
                return window.traitCollection.userInterfaceStyle
            }
        }
        
        return nil
    }
    
    func setUserInterfaceStyle(to style: UIUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle) {
        if let window = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if #available(iOS 15.0, *) {
                window.windows.first?.overrideUserInterfaceStyle = style
            }
        } else if let window = UIApplication.shared.windows.first {
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = style
            } else {
                window.overrideUserInterfaceStyle = style
            }
        }
    }
}

