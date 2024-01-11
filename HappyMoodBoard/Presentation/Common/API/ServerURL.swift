//
//  ServerURL.swift
//  HappyMoodBoard
//
//  Created by ukBook on 1/10/24.
//

import Foundation

enum ServerURL {
    case testLogin
    case login
    
    var baseURL: String {
        #if DEBUG
        return "https://dev.beehappy.today"
        #else
        return "https://api.beehappy.today/"
        #endif
    }
    
    var url: String {
        switch self {
        case .testLogin:
            return baseURL + "/test/api/auth/v1/login/social"
        case .login:
            return baseURL + "/api/auth/v2/login/social"
        }
    }
}
