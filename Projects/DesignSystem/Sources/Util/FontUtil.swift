//
//  FontUtil.swift
//  DesignSystem
//
//  Created by 김유진 on 2023/12/03.
//

import UIKit

public enum Font {
    public static func black(size: CGFloat) -> UIFont {
        return DesignSystemFontConvertible(name: "Pretendard-Black",
                                           family: "Pretendard",
                                           path: "Pretendard-Black.otf").font(size: moderateScale(number: size))
    }
    
    public static func bold(size: CGFloat) -> UIFont {
        return DesignSystemFontConvertible(name: "Pretendard-Bold",
                                           family: "Pretendard",
                                           path: "Pretendard-Bold.otf").font(size: moderateScale(number: size))
    }
    
    public static func extraBold(size: CGFloat) -> UIFont {
        return DesignSystemFontConvertible(name: "Pretendard-ExtraBold",
                                           family: "Pretendard",
                                           path: "Pretendard-ExtraBold.otf").font(size: moderateScale(number: size))
    }
    
    public static func extraLight(size: CGFloat) -> UIFont {
        return DesignSystemFontConvertible(name: "Pretendard-ExtraLight",
                                           family: "Pretendard",
                                           path: "Pretendard-ExtraLight.otf").font(size: moderateScale(number: size))
    }
    
    public static func medium(size: CGFloat) -> UIFont {
        return DesignSystemFontConvertible(name: "Pretendard-Medium",
                                           family: "Pretendard",
                                           path: "Pretendard-Medium.otf").font(size: moderateScale(number: size))
    }
    
    public static func regular(size: CGFloat) -> UIFont {
        return DesignSystemFontConvertible(name: "Pretendard-Regular",
                                           family: "Pretendard",
                                           path: "Pretendard-Regular.otf").font(size: moderateScale(number: size))
    }
    
    public static func semiBold(size: CGFloat) -> UIFont {
        return DesignSystemFontConvertible(name: "Pretendard-SemiBold",
                                           family: "Pretendard",
                                           path: "Pretendard-SemiBold.otf").font(size: moderateScale(number: size))
    }
    
    public static func thin(size: CGFloat) -> UIFont {
        return DesignSystemFontConvertible(name: "Pretendard-Thin",
                                           family: "Pretendard",
                                           path: "Pretendard-Thin.otf").font(size: moderateScale(number: size))
    }
}
