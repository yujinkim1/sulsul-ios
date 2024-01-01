//
//  UILabel+Extension.swift
//  DesignSystem
//
//  Created by Yujin Kim on 2023-12-19.
//

import UIKit

public extension UILabel {
    func setTextLineHeight(height: CGFloat) {
        if let text = self.text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = height
            style.minimumLineHeight = height
            
            let attributes: [NSAttributedString.Key : Any] = [
                .paragraphStyle : style,
                .baselineOffset: (height - font.lineHeight) / 4
            ]
            
            let attributeString = NSAttributedString(string: text, attributes: attributes)
            attributedText = attributeString
        }
    }
}
