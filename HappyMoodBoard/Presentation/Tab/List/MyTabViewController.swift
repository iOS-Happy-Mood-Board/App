//
//  MyTabViewController.swift
//  HappyMoodBoard
//
//  Created by 홍다희 on 2023/12/20.
//

import UIKit

import Then
import SnapKit

import RxSwift
import RxCocoa

final class MyTabViewController: UIViewController {
    
    private let settingButton: UIBarButtonItem = .init(
        image: .init(named: "setting"),
        style: .plain,
        target: nil,
        action: nil
    )
    
    static let kHeaderLabelText = "님께 필요한\n행복을 꺼내 먹어요."
    
    private let headerLabel: UILabel = .init().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    let disposeBag : DisposeBag = .init()
    let viewModel: MyTabViewModel = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSubviews()
        setupLayouts()
        setupBindings()
    }

}

extension MyTabViewController: ViewAttributes {
    
    func setupNavigationBar() {
        let spacing = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacing.width = 12
        
        let titleLabel = UILabel().then {
            $0.textColor = .primary900
            $0.font = .init(name: "Pretendard-Bold", size: 16)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.17
            $0.attributedText = NSMutableAttributedString(
                string: "BEE HAPPY",
                attributes: [
                    NSAttributedString.Key.kern: -0.32,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ]
            )
        }
//        titleLabel.sizeToFit()
        
        navigationItem.leftBarButtonItems = [spacing, .init(customView: titleLabel)]
        navigationItem.rightBarButtonItems = [settingButton, spacing]
    }
    
    func setupSubviews() {
        [
            headerLabel
        ].forEach { self.view.addSubview($0) }
    }
    
    func setupLayouts() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(8)
            make.leading.trailing.equalToSuperview().offset(24)
        }
    }
    
    func setupBindings() {
        let input = MyTabViewModel.Input (
            viewWillAppear: rx.viewWillAppear.asObservable(),
            navigationRight: settingButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.username.asDriver(onErrorJustReturn: "")
            .debug("사용자명")
            .drive(with: self) { owner, username in
                let text = "\(username) \(Self.kHeaderLabelText)"
                owner.headerLabel.text = text
                let attributedString = NSMutableAttributedString(string: text)
                attributedString.addAttribute(
                    .foregroundColor,
                    value: UIColor.primary900,
                    range: (text as NSString).range(of: username)
                )
                owner.headerLabel.attributedText = attributedString
            }
            .disposed(by: disposeBag)
        
        output.navigationRight.asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                let settingViewController = SettingIndexViewController()
                settingViewController.hidesBottomBarWhenPushed = true // Tabbar 숨기기
                owner.show(settingViewController, sender: nil)
            }
            .disposed(by: disposeBag)
    }
}
