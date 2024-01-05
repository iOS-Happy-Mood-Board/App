//
//  SettingNotificationViewController.swift
//  HappyMoodBoard
//
//  Created by ukBook on 12/25/23.
//

import Foundation

import Then
import SnapKit

import RxSwift
import RxCocoa
import RxViewController


final class SettingNotificationViewController: UIViewController, ViewAttributes, UIGestureRecognizerDelegate {
    
    // 네비게이션
    private let navigationTitle = NavigationTitle(title: "알림 설정")
    private let navigationItemBack = NavigtaionItemBack()
    //
    
    private lazy var dimView = UIView(frame: view.bounds).then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        $0.alpha = 0
    }
    
    private let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 0
    }
    
    private let disposeBag: DisposeBag = .init()
    private let viewModel: SettingNotificationViewModel = .init()
    
    override func viewDidLoad() {
        
        setCommonBackgroundColor()
        setupNavigationBar()
        setupSubviews()
        setupLayouts()
        setupBindings()
    }
}

extension SettingNotificationViewController {
    func setupNavigationBar() {
        self.navigationItem.titleView = navigationTitle
        self.navigationItem.leftBarButtonItem = navigationItemBack
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func setupSubviews() {
        [
            dimView
        ].forEach { self.view.addSubview($0) }
    }
    
    func setupLayouts() {
        
    }
    
    func setupBindings() {
        let input = SettingNotificationViewModel.Input(
            viewWillAppear: rx.viewWillAppear.asObservable(),
            navigateToBack: navigationItemBack.rxTap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.navigateToBack.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        output.systemNotification
            .bind { [weak self] handler in
                
                if !handler {
                    self?.dimView.alpha = 0.0 // 투명도를 조정하여 딤 효과를 줍니다.
                } else {
                    self?.dimView.alpha = 1.0 // 투명도를 조정하여 딤 효과를 줍니다.
                    
                    let VC = NotificationModalViewController()
                    VC.modalPresentationStyle = .custom
                    VC.transitioningDelegate = self
                    self?.present(VC, animated: true, completion: nil)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension SettingNotificationViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
