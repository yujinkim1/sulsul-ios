//
//  ProfileSettingViewModel.swift
//  Feature
//
//  Created by 이범준 on 1/21/24.
//

import Foundation
import Combine
import Alamofire
import Service

struct ProfileSettingViewModel {
    private let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIiLCJpYXQiOjE3MDU3NDk4MDEsImV4cCI6MTcwNjM1NDYwMSwiaWQiOjEsInNvY2lhbF90eXBlIjoiZ29vZ2xlIiwic3RhdHVzIjoiYWN0aXZlIn0.gucj-5g1CktXtAKqYp99K-_eI7sH_VmoyDTaVhKE6DU"
    private let jsonDecoder = JSONDecoder()
    private var cancelBag = Set<AnyCancellable>()
    
    private var deleteUser = PassthroughSubject<Void, Never>()
    
    init() {
        deleteUser
            .sink {
                // 삭제 api 호출
            }.store(in: &cancelBag)
    }
    
    func sendDeleteUser() {
        deleteUser.send(())
    }
}
