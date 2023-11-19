//
//  ScreenUtil.swift
//  DesignSystem
//
//  Created by 이범준 on 11/19/23.
//

import UIKit

// TODO: 피그마 확인 후 가이드 값 수정
let baseGuideWidth: CGFloat = 375.0
let baseGuideHeight: CGFloat = 667.0

@inline(__always)
func horizontalScale(number: CGFloat) -> CGFloat {
    UIScreen.main.bounds.width / baseGuideWidth * number
}

@inline(__always)
func verticalScale(number: CGFloat) -> CGFloat {
    let number = UIScreen.main.bounds.height / baseGuideHeight * number
    if UIScreen.main.bounds.width / UIScreen.main.bounds.height <= 0.75 {
        return number * 1.2
    }
    return UIScreen.main.bounds.height / baseGuideHeight * number
}

@inline(__always)
func moderateScale(number: CGFloat, factor: CGFloat = 0.5) -> CGFloat {
    number + (horizontalScale(number: number ) - number) * factor
}

@inline(__always)
func getSafeAreaTop() -> CGFloat {
    UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.top ?? 0
}

@inline(__always)
func getSafeAreaBottom() -> CGFloat {
    UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.bottom ?? 0
}

@inline(__always)
func isLandscapeIPad() -> Bool {
    guard let firstScene = UIApplication.shared.windows.first?.windowScene else { return false }
    return UIDevice.current.userInterfaceIdiom == .pad && (firstScene.interfaceOrientation == .landscapeLeft || firstScene.interfaceOrientation == .landscapeRight)
}

