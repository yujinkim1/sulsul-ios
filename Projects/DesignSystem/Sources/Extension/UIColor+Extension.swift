//
//  UIColor+Extension.swift
//  DesignSystem
//
//  Created by 이범준 on 2023/08/24.
//

import UIKit

// MARK: - Color 지정
public extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
    
    static var purple400 = UIColor(named: "purple400") ?? .init(r: 135, g: 94, b: 249)
}
