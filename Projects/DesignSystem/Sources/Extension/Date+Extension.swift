//
//  Date+Extension.swift
//  DesignSystem
//
//  Created by 김유진 on 3/12/24.
//

import Foundation

public enum DateFormat: String {
    case yyyy년_MM월_dd일 = "yyyy년 MM월 dd일"
}

extension Date {
    public func relativeDate(_ format: DateFormat = .yyyy년_MM월_dd일) -> String {
        if (Date().timeIntervalSince1970 - self.timeIntervalSince1970) > 2592000 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format.rawValue
            dateFormatter.locale = Locale(identifier: "ko_KR")
            return dateFormatter.string(from: self)
        } else {
            let formatter = RelativeDateTimeFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.unitsStyle = .abbreviated
            return formatter.localizedString(for: self, relativeTo: Date())
        }
    }
}
