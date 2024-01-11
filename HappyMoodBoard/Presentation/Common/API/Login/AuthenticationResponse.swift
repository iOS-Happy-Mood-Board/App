//
//  AuthenticationResponse.swift
//  HappyMoodBoard
//
//  Created by ukBook on 1/10/24.
//

import Foundation

struct AuthenticationResponse: Codable {
    let data: AuthenticationData
    let timestamp: Int
}

struct AuthenticationData: Codable {
    let status: String
    let accessToken: String
    let refreshToken: String
}
