//
//  DetailFeed.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-14.
//

import Foundation

struct DetailFeed: Decodable {
    let feedID: Int
    let title: String
    let content: String
    let representImage: String
    let images: [String]
    let alcoholPairingIDs: [Int]
    let foodPairingIDs: [Int]
    let isLiked: Bool
    let viewCount: Int
    let likesCount: Int
    let commentsCount: Int
    let score: Int
    let createdAt: String
    let updatedAt: String
}
