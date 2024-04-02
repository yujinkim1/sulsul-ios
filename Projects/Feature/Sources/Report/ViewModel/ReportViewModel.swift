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
    
    private let jsonDecoder = JSONDecoder()
    private var cancelBag = Set<AnyCancellable>()
    private let accessToken = KeychainStore.shared.read(label: "accessToken")
    
    private let errorSubject = PassthroughSubject<String, Never>()
    private let reportSuccess = PassthroughSubject<Void, Never>()
    
    private let reportReasons: [ReportReason] = [.profanity,
                                                 .conflict,
                                                 .spam,
                                                 .inappropriateNickname,
                                                 .other]
    init() {
        
    }
    // TODO: - 신고 완료 시 api 호출 -> (피드 아이디 없어서 연동 아직 X)
    func setReports(reason: String, type: ReportType, targetId: Int) {
        let params: [String: Any] = ["reason": reason,
                                     "type": type,
                                     "target_id": targetId]
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken!
        ]
        NetworkWrapper.shared.postBasicTask(stringURL: "/reports", parameters: params, header: headers) {[weak self] result in
            switch result {
            case .success(let response):
                self?.reportSuccess.send(())
            case .failure(let error):
                self?.errorSubject.send(error.localizedDescription)
            }
            
        }
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
}
