//
//  ModifyNickNameViewController.swift
//  HappyMoodBoard
//
//  Created by ukBook on 1/3/24.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa

import RxKeyboard

final class ModifyNickNameViewController: UIViewController, ViewAttributes, UIGestureRecognizerDelegate {
    
    // 네비게이션
    private let navigationTitle = NavigationTitle(title: "닉네임 수정")
    private let navigationItemBack = NavigtaionItemBack()
    //
    
    private let nicknameTextField = UITextField().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-Bold", size: 22)
        $0.attributedPlaceholder = .init(
            string: "최대 10자까지 쓸 수 있어요.",
            attributes: [
                .foregroundColor: UIColor.gray400
            ]
        )
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = .primary500
    }
    
    private let nextButton = UIButton(type: .system).then {
        $0.configurationUpdateHandler = { button in
            var container = AttributeContainer()
            container.font = UIFont(name: "Pretendard-Bold", size: 16)
            container.foregroundColor = button.isEnabled ? .gray900 : .gray400
            var configuration = UIButton.Configuration.filled()
            configuration.cornerStyle = .capsule
            configuration.background.backgroundColor = button.isEnabled ? .primary500 : .gray200
            configuration.attributedTitle = AttributedString("완료", attributes: container)
            button.configuration = configuration
        }
        $0.isEnabled = false
    }
    
    private let viewModel: ModifyNickNameViewModel = .init()
    private let disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCommonBackgroundColor()
        setupNavigationBar()
        setupSubviews()
        setupLayouts()
        setupBindings()
    }
    
    func setupNavigationBar() {
        self.navigationItem.titleView = navigationTitle
        self.navigationItem.leftBarButtonItem = navigationItemBack
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func setupSubviews() {
        [
            nicknameTextField,
            divider,
            nextButton
        ].forEach { view.addSubview($0) }
    }
    
    func setupLayouts() {
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
            $0.height.equalTo(41)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(7)
            $0.height.equalTo(2)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-26)
            $0.height.equalTo(52)
        }
    }
    
    func setupBindings() {
        RxKeyboard.instance.visibleHeight
            .drive(with: self) { owner, keyboardVisibleHeight in
                owner.nextButton.snp.updateConstraints {
                    $0.bottom.equalTo(owner.view.safeAreaLayoutGuide.snp.bottom).offset(-keyboardVisibleHeight)
                }
                owner.view.setNeedsLayout()
            }
            .disposed(by: disposeBag)
                
        let input = ModifyNickNameViewModel.Input(
            navigateToBack: navigationItemBack.rxTap.asObservable(),
            nickname: nicknameTextField.rx.text.orEmpty.asObservable(),
            confirmEvent: nextButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.navigateToBack.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        .disposed(by: disposeBag)
        
        output.nickname.asDriver(onErrorJustReturn: "")
            .drive(nicknameTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.isValid.asDriver(onErrorJustReturn: false)
            .drive(nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.success.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        .disposed(by: disposeBag)
        
        output.failure.bind { [weak self] in
            makeToast($0)
        }
        .disposed(by: disposeBag)
    }
}
