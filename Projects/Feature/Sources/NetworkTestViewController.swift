//
//  NetworkTestViewController.swift
//  Feature
//
//  Created by 이범준 on 2023/11/21.
//

import UIKit
import Service
import Combine

public final class NetworkTestViewController: UIViewController {
    private let jsonDecoder = JSONDecoder()
    public override func viewDidLoad() {
        print("화면 시작")
        NetworkWrapper.shared.getBasicTask(stringURL: "/v1/pairings") { result in
            switch result {
            case .success(let responseData):
                if let adData = try? self.jsonDecoder.decode(AdModel.self, from: responseData) {
                    print(adData.pairings)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct AdModel: Codable {
    var pairings: [Pairing]
}
struct Pairing: Codable {
    var id: Int?
    var type: String?
    var name: String?
    var image: String?
    var description: String?
}
