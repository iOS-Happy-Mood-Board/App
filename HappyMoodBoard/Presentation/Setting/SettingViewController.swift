//
//  SettingViewController.swift
//  HappyMoodBoard
//
//  Created by ukseung.dev on 12/22/23.
//

import Foundation

import Then
import SnapKit

import RxSwift
import RxCocoa


final class SettingViewController: UIViewController {
    
    private let navigationTitle = NavigationTitle(title: "설정")
    private let navigationItemBack = NavigtaionItemBack()
    
    override func viewDidLoad() {
        
        setCommonBackgroundColor()
        setupNavigationBar()
        setupSubviews()
        setupLayouts()
        setupBindings()
    }
    
    let disposeBag = DisposeBag()
}

extension SettingViewController: ViewAttributes {
    func setupNavigationBar() {
        self.navigationItem.titleView = navigationTitle
        self.navigationItem.leftBarButtonItem = navigationItemBack
    }
    
    func setupSubviews() {
        
    }
    
    func setupLayouts() {
        
    }
    
    func setupBindings() {
        navigationItemBack.rxTap
            .subscribe(onNext: { [weak self] in
                
            })
    }
}
