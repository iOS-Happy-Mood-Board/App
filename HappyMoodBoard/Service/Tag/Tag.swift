//
//  Tag.swift
//  HappyMoodBoard
//
//  Created by 홍다희 on 2024/01/02.
//

import Foundation

struct Tag: Decodable {
    let id: Int
    let tagName: String
    let tagColorId: Int
}
