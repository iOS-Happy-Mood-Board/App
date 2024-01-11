//
//  Login.swift
//  HappyMoodBoard
//
//  Created by ukBook on 1/10/24.
//

import Foundation

enum Login {
    static var fcmToken: String? {
        return UserDefaults.standard.string(forKey: "deviceToken")
    }
    
    case deviceToken
    case deviceType
    case deviceId
    
    var value: String {
        switch self {
        case .deviceToken:
            return Login.fcmToken ?? ""
        case .deviceType:
            return "ios"
        case .deviceId:
            return UUID().uuidString
        }
    }
}
