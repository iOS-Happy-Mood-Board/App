//
//  ApiService.swift
//  HappyMoodBoard
//
//  Created by 홍다희 on 2024/01/09.
//

import Foundation

import RxSwift
import RxAlamofire

class ApiService {
    
    private let scheduler: ConcurrentDispatchQueueScheduler = .init(qos: DispatchQoS(qosClass: .background, relativePriority: 1))
    
    func request<T: Decodable>(type: T.Type, target: TargetType) -> Observable<T?> {
        return RxAlamofire
            .request(target, interceptor: AuthInterceptor())
            .observe(on: MainScheduler.instance)
            .responseData()
            .map { response, data -> T? in
                switch response.statusCode {
                case 200...299:
                    let result = try? JSONDecoder().decode(BaseResponse<T>.self, from: data)
                    return result?.data
                default:
                    let apiError = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                    print(
                        target.path,
                        "💥💥💥",
                        response.statusCode,
                        apiError ?? (String(data: data, encoding: .utf8) ?? "")
                    )
                    return nil
                }
            }
    }
    
}


