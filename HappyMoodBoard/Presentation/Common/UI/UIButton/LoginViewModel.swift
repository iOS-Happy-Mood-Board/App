//
//  LoginViewModel.swift
//  HappyMoodBoard
//
//  Created by ukBook on 12/28/23.
//

import Foundation

import AuthenticationServices

import RxSwift
import RxCocoa

import Alamofire

final class LoginViewModel: NSObject, ViewModel {
    struct Input {
        let kakaoLogin: Observable<Void>
        let appleLogin: Observable<Void>
    }
    
    struct Output {
        let kakaoLogin: Observable<Void>
        let appleLogin: Observable<AuthenticationResponse>
    }
    
    let socialResponse = PublishSubject<AuthenticationResponse>()
    
    let disposeBag: DisposeBag = .init()
    let API = APIService.shared
    
    func transform(input: Input) -> Output {
        
        let apple = input.appleLogin
            .subscribe(onNext: {
                self.handleAppleSignIn()
            })
            .disposed(by: disposeBag)
        
        return Output(
            kakaoLogin: input.kakaoLogin,
            appleLogin: socialResponse.asObservable()
        )
    }
}

extension LoginViewModel: ASAuthorizationControllerDelegate {
    func handleAppleSignIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            // You can create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("identityToken: \(identityToken)")
                print("authCodeString: \(authCodeString)")
                print("identifyTokenString: \(identifyTokenString)")
                
                let headers: HTTPHeaders = [
                    "Content-Type": "application/json;charset=UTF-8"
                ]
                
                let parameters: Parameters = [
                    "accessToken": identifyTokenString,
                    "provider": "apple",
                    "deviceToken": Login.deviceToken.value,
                    "deviceType": Login.deviceType.value,
                    "deviceId": Login.deviceId.value
                ]
                
                print(parameters)
                
                API.request(
                    url: ServerURL.login.url,
                    method: .post,
                    parameters: parameters,
                    headers: headers
                )
                .subscribe(onNext: { [weak self] in
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode(AuthenticationResponse.self, from: $0)
                        print("Status: \(response.data.status)")
                        print("Access Token: \(response.data.accessToken)")
                        print("Refresh Token: \(response.data.refreshToken)")
                        
                        let accessToken = response.data.accessToken
                        let refreshToken = response.data.refreshToken
                        UserDefaults.standard.set(accessToken, forKey: "accessToken")
                        UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                        
                        // 여기 결과 값을 Output.appleLogin에 넣고싶음
                        self?.socialResponse.onNext(response)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                })
                .disposed(by: disposeBag)
            }
            
            print("useridentifier: \(userIdentifier)")
            print("fullName: \(fullName)")
            print("email: \(email)")
            
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("username: \(username)")
            print("password: \(password)")
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Apple 인증에서 에러가 발생한 경우 처리
    }
}
