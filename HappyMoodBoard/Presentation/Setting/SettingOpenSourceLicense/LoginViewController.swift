//
//  LoginViewController.swift
//  HappyMoodBoard
//
//  Created by ukBook on 12/28/23.
//

import Foundation

import Then
import SnapKit

import RxSwift
import RxCocoa

enum LoginResponseStatus {
    case requiredConsent // 이용약관 동의 전(=회원가입 플로우)
    case active // 실제 활성 회원
    case suspend // 차단된 회원
    
    var value: String {
        switch self {
        case .requiredConsent:
            return "REQUIRED_CONSENT"
        case .active:
            return "ACTIVE"
        case .suspend:
            return "SUSPEND"
        }
    }
}

final class LoginViewController: UIViewController, ViewAttributes {
    
    private let kakaoLoginButton = SocialLoginButton(type: .kakao)
    private let appleLoginButton = SocialLoginButton(type: .apple)
    
    private let viewModel: LoginViewModel = .init()
    private let disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        setupSubviews()
        setupLayouts()
        setupBindings()
    }
}

extension LoginViewController {
    func setupSubviews() {
        [
            kakaoLoginButton,
            appleLoginButton
        ].forEach { self.view.addSubview($0) }
    }
    
    func setupLayouts() {
        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-26)
            $0.leading.equalTo(24)
            $0.trailing.equalTo(-24)
            $0.height.equalTo(52)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.leading.trailing.height.equalTo(appleLoginButton)
            $0.bottom.equalTo(appleLoginButton.snp.top).offset(-16)
        }
    }
    
    func setupBindings() {
        
        let input = LoginViewModel.Input(
            kakaoLogin: kakaoLoginButton.rx.tap.asObservable(),
            appleLogin: appleLoginButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        // 카카오 로그인
        output.kakaoLogin.bind { [weak self] in
            print("카카오 로그인")
        }
        .disposed(by: disposeBag)
        
        // 애플 로그인
        output.appleLogin
            .map {
                $0.data.status
            }
            .bind { [weak self] handler in
                
                switch handler {
                case LoginResponseStatus.requiredConsent.value: // 회원 아님, 회원가입 플로우
                    let viewController = AgreeViewController()
                    self?.show(viewController, sender: nil)
                case LoginResponseStatus.active.value: // 회원
                    traceLog("2")
                case LoginResponseStatus.suspend.value: // 차단된 사용자
                    traceLog("3")
                default:
                    traceLog("오류")
                }
            }
            .disposed(by: disposeBag)
    }
}
