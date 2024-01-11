//
//  LoginAPIService.swift
//  HappyMoodBoard
//
//  Created by ukBook on 1/7/24.
//

import Foundation

import Alamofire
import RxSwift
import RxCocoa

final class LoginAPIService {
    func postDataToAPI() -> Observable<Data> {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json;charset=UTF-8"
        ]
        
        let parameters: Parameters = [
            "provider": "apple",
            "providerId": "1234567890",
            "deviceToken": Login.deviceToken.value,
            "deviceType": Login.deviceType.value,
            "deviceId": Login.deviceId.value
        ]
        
        dump(parameters)
        
        return Observable.create { observer in
            let request = AF.request("https://dev.beehappy.today/test/api/auth/v1/login/social",
                                     method: .post,
                                     parameters: parameters,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        print(String(data: data, encoding: .utf8))
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        print(error)
                        observer.onError(error)
                    }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

