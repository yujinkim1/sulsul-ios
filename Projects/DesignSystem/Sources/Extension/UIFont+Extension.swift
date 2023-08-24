//
//  UIFont+Extension.swift
//  DesignSystem
//
//  Created by 이범준 on 2023/08/24.
//

import UIKit

// MARK: - 폰트 지정시, 임시 폰트 pretendard 넣어놓음 추후 수정 예정
public extension UIFont {
    enum Family {
        case Black, Bold, ExtraBold, ExtraLight, Light, Medium, Regular, SemiBold, Thin
    }
    
    static func setFont(size: CGFloat = 10, family: Family = .Regular) -> UIFont? {
        return UIFont(name: "Pretendard-\(family)", size: size)
    }
}
