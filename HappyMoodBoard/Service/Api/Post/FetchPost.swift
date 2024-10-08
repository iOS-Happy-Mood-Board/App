//
//  FetchPost.swift
//  HappyMoodBoard
//
//  Created by 홍다희 on 2024/01/18.
//

import Foundation

struct FetchPostParamaters: Encodable {
    let tagId: Int?
    let postId: Int?
}

struct FetchPostResponse: Decodable {
    let createdAt: String
    let id: Int
    let postTag: Tag?
    let comments: String?
    let imagePath: String?
}
