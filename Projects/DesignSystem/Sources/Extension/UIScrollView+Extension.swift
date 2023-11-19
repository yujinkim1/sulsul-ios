//
//  UIScrollView+Extension.swift
//  DesignSystem
//
//  Created by 이범준 on 11/19/23.
//

import UIKit

extension UIScrollView {
    func scrollToTop(animated: Bool) {
        let y = -contentInset.top - adjustedContentInset.top
        
        if contentOffset.y == y {
            return
        }
        
        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }
    
    func scrollToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: animated)
        }
    }
}
