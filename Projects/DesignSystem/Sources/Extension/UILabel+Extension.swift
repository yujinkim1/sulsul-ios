//
//  UILabel+Extension.swift
//  DesignSystem
//
//  Created by 김유진 on 2024/01/02.
//

import UIKit

extension UILabel {
    public func setLineHeight(_ lineHeight: CGFloat) {
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 4
            ]
            
            let attrString = NSAttributedString(string: text, attributes: attributes)
            self.attributedText = attrString
        }
    }
    
    public func setFontForText(_ targetText: String, withFont font: UIFont) {
         guard let labelText = text, let range = labelText.range(of: targetText) else {
             return
         }
         
         let nsRange = NSRange(range, in: labelText)
         
         let attributedString = NSMutableAttributedString(string: labelText)
         attributedString.addAttribute(.font, value: font, range: nsRange)
         
         attributedText = attributedString
     }
    
    public func setFontAndColorForText(_ targetText: String, withFont font: UIFont, textColor: UIColor) {
        guard let labelText = text, let range = labelText.range(of: targetText) else {
            return
        }
        
        let nsRange = NSRange(range, in: labelText)
        
        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(.font, value: font, range: nsRange)
        attributedString.addAttribute(.foregroundColor, value: textColor, range: nsRange)
        
        attributedText = attributedString
    }
}
