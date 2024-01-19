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
    
    private lazy var scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    
    private let contentView = UIView()
    
    static let kHeaderLabelText = "님께 필요한\n행복을 꺼내 먹어요."
    
    private let headerLabel: UILabel = .init().then {
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    private let tagScrollView = UIScrollView().then {
//        $0.backgroundColor = .systemRed
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false // 수평 스크롤 인디케이터 표시 여부
        $0.isDirectionalLockEnabled = true // 수평 스크롤 고정 여부 (수직 스크롤을 막고 수평 스크롤만 허용)
        $0.alwaysBounceHorizontal = true // 스크롤이 컨텐츠의 크기보다 작아도 가로로 스크롤 가능하도록 설정
        $0.isPagingEnabled = false // 페이지별 스크롤 여부 (필요에 따라 설정)
        $0.isScrollEnabled = true
    }
    
    private let tagStackView = UIStackView().then {
        $0.layer.borderWidth = 1
//        $0.backgroundColor = .green
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    private let stickyHeaderView = UIScrollView().then {
        $0.backgroundColor = .systemRed
        $0.isHidden = true
    }
    
    private let tableView = UITableView().then {
        $0.layer.borderWidth = 1
        $0.backgroundColor = .systemCyan
    }
    
    let disposeBag : DisposeBag = .init()
    let viewModel: MyTabViewModel = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCommonBackgroundColor()
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
            scrollView,
            stickyHeaderView
        ].forEach { self.view.addSubview($0) }
        
        [
            contentView
        ].forEach { self.scrollView.addSubview($0) }
        
        [
            headerLabel,
            tagScrollView,
            tableView
        ].forEach { self.contentView.addSubview($0) }
        
        [
            tagStackView
        ].forEach { self.tagScrollView.addSubview($0) }
    }
    
    func setupLayouts() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
        stickyHeaderView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(46)
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(view.snp.width)
        }
        
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        tagScrollView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(46)
        }
        
        tagStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(tagScrollView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1900)
        }
    }
    
    func setupBindings() {
        // 스택 뷰에 추가할 뷰들 생성
        for i in 0 ..< 6 {
            let subview = UIButton()
            subview.setTitle("전체", for: .normal)
            subview.setTitleColor(.black, for: .normal)
            subview.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
            subview.backgroundColor = .primary100
            subview.layer.cornerRadius = 13
            subview.layer.borderWidth = 1
            subview.layer.borderColor = UIColor.primary600?.cgColor
            tagStackView.addArrangedSubview(subview)

            // Auto Layout 설정 (SnapKit 사용)
            subview.snp.makeConstraints {
                $0.width.equalTo(73)
                $0.height.equalTo(30)
//                $0.centerY.equalTo(tagStackView)
                
                if i == 0 {
                    $0.leading.equalTo(tagStackView.snp.leading).offset(24)
                } else if i == 5 {
                    $0.trailing.equalTo(tagStackView.snp.trailing).offset(-24)
                }
            }
        }
        
        let input = MyTabViewModel.Input (
            viewWillAppear: rx.viewWillAppear.asObservable(),
            navigationRight: settingButton.rx.tap.asObservable(),
            scrollViewDidScroll: scrollView.rx.didScroll.asObservable()
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
        
        output.scrollViewDidScroll
            .skip(2) // TODO: 이 line을 없애면 처음에 stickyView가 노출, 일단 하드코딩..
            .bind { [weak self] in
                // 5. 핵심 - frame.minY를 통해 sticky 타이밍을 계산
                //            traceLog(self?.scrollView.contentOffset.y)
                //            traceLog(self?.tagView.frame.minY)
                let shouldShowSticky = (self?.scrollView.contentOffset.y)! >= (self?.tagScrollView.frame.minY)!
                self?.stickyHeaderView.isHidden = !shouldShowSticky
            }
            .disposed(by: disposeBag)
    }
}
