//
//  ReportViewModel.swift
//  Feature
//
//  Created by 이범준 on 2023/12/25.
//

import Foundation
import Combine
import Service
import Alamofire

enum ReportType: String {
    case feed = "feed"
    case comment = "comment"
}

enum ReportReason: String {
    case profanity = "🤬 비속어/폭언/비하/음란성 내용"
    case conflict = "🤯 갈등 조장 및 허위사실 유포"
    case spam = "🤑 도배/광고성 내용/종교 권유"
    case inappropriateNickname = "😱 부적절한 닉네임 사용"
    case other = "💬 그 외 기타사유"
}


final class ReportViewModel {
    
    private let reportType: ReportType
    private let targetId: Int
    private let jsonDecoder = JSONDecoder()
    private var cancelBag = Set<AnyCancellable>()
    
    private let errorSubject = PassthroughSubject<String, Never>()
    private let reportSuccess = PassthroughSubject<Void, Never>()
    private let currentReportContent = CurrentValueSubject<String, Never>("")
    
    private let reportReasons: [ReportReason] = [.profanity,
                                                 .conflict,
                                                 .spam,
                                                 .inappropriateNickname,
                                                 .other]
    init(reportType: ReportType, targetId: Int) {
        self.reportType = reportType
        self.targetId = targetId
    }
    
    func setReports(reason: String, type: ReportType, targetId: Int) {
        guard let accessToken = KeychainStore.shared.read(label: "accessToken") else { return }
        
        let params: [String: Any] = ["reason": reason,
                                     "type": type.rawValue,
                                     "target_id": targetId]
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken
        ]
        NetworkWrapper.shared.postBasicTask(stringURL: "/reports", parameters: params, header: headers) { [weak self] result in
            switch result {
            case .success(let response):
                self?.reportSuccess.send(())
            case .failure(let error):
                self?.errorSubject.send(error.localizedDescription)
            }
            
        }
    }
    
    func reportSuccessPublisher() -> AnyPublisher<Void, Never> {
        return reportSuccess.eraseToAnyPublisher()
    }
    
    func reportListCount() -> Int {
        return reportReasons.count
    }
    
    func getReportList(_ index: Int) -> String {
        return reportReasons[index].rawValue
    }
    
    func getErrorSubject() -> AnyPublisher<String, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    func sendCurrentReportContent(_ content: String) {
        currentReportContent.send(content)
    }
    
    func sendReportContent() {
        setReports(reason: currentReportContent.value, type: self.reportType, targetId: self.targetId)
    }
    
    func currentReportContentPublisher() -> AnyPublisher<String, Never> {
        return currentReportContent.eraseToAnyPublisher()
    }
    
    func currentReportContentValue() -> String {
        return currentReportContent.value
    }
}

