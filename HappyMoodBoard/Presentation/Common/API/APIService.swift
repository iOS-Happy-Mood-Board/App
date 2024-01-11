//
//  APIService.swift
//  HappyMoodBoard
//
//  Created by ukBook on 1/7/24.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

final class APIService {
    static let shared = APIService() // 싱글톤 객체
    
    /// 서버 요청 함수
    /// - Parameters:
    ///   - url: URL
    ///   - parameters: 요청 파라미터
    ///   - headers: 헤더
    /// - Returns: Observable<Data>
    func request(url: String, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) -> Observable<Data> {
        return Observable.create { observer in
            let request = AF.request(url,
                                     method: method,
                                     parameters: parameters,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
