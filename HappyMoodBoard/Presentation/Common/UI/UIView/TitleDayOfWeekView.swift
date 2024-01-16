//
//  TitleDayOfWeekView.swift
//  HappyMoodBoard
//
//  Created by ukBook on 1/6/24.
//

import Foundation

import SnapKit
import Then

import RxSwift

final class TitleDayOfWeekView: UIView, ViewAttributes {
    
    private let titleLabel = CustomLabel(
        text: nil,
        textColor: UIColor.black,
        font: UIFont(name: "Pretendard-Regular", size: 16)
    )
    
    private let contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.alignment = .center
        $0.distribution = .fillProportionally
//        $0.layer.borderWidth = 1
    }
    
    private let mondayButton = PushNotificationButton(
        title: DayOfTheWeek.monday.title,
        titleColor: .black,
        titleFont: UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont(),
        backgroundColor: .gray200 ?? UIColor(),
        radius: 4
    )

    private let tuesdayButton = PushNotificationButton(
        title: DayOfTheWeek.tuesday.title,
        titleColor: .black,
        titleFont: UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont(),
        backgroundColor: .gray200 ?? UIColor(),
        radius: 4
    )

    private let wednesdayButton = PushNotificationButton(
        title: DayOfTheWeek.wednesday.title,
        titleColor: .black,
        titleFont: UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont(),
        backgroundColor: .gray200 ?? UIColor(),
        radius: 4
    )

    private let thursdayButton = PushNotificationButton(
        title: DayOfTheWeek.thursday.title,
        titleColor: .black,
        titleFont: UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont(),
        backgroundColor: .gray200 ?? UIColor(),
        radius: 4
    )

    private let fridayButton = PushNotificationButton(
        title: DayOfTheWeek.friday.title,
        titleColor: .black,
        titleFont: UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont(),
        backgroundColor: .gray200 ?? UIColor(),
        radius: 4
    )
    
    private let saturdayButton = PushNotificationButton(
        title: DayOfTheWeek.saturday.title,
        titleColor: .black,
        titleFont: UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont(),
        backgroundColor: .gray200 ?? UIColor(),
        radius: 4
    )

    private let sundayButton = PushNotificationButton(
        title: DayOfTheWeek.sunday.title,
        titleColor: .black,
        titleFont: UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont(),
        backgroundColor: .gray200 ?? UIColor(),
        radius: 4
    )

    private let everydayButton = PushNotificationButton(
        title: DayOfTheWeek.everyday.title,
        titleColor: .black,
        titleFont: UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont(),
        backgroundColor: .gray200 ?? UIColor(),
        radius: 4
    )
    
    let disposeBag: DisposeBag = .init()
    let dayOfWeekPublicSubject = PublishSubject<[Int]>()
    
    // TODO: 테스트 데이터 삭제 해야함
    let testArray = [0, 1, 3, 4, 5, 6]
    
    init(type: SettingNotificationType) {
        super.init(frame: .zero)
        
        setupSubviews()
        setupLayouts()
        setupBindings()
        
        titleLabel.text = type.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TitleDayOfWeekView {
    func setupSubviews() {
        [
            titleLabel,
            contentStackView
        ].forEach { addSubview($0) }
        
        [
            mondayButton,
            tuesdayButton,
            wednesdayButton,
            thursdayButton,
            fridayButton,
            saturdayButton,
            sundayButton,
            everydayButton
        ].forEach { contentStackView.addArrangedSubview($0) }

    }
    
    func setupLayouts() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(45)
        }
    }
    
    func setupBindings() {
        dayOfWeekPublicSubject.bind { [weak self] in
            // TODO: 테스트 코드, 삭제
//            self?.bindDayOfWeek(dayOfWeek: self!.testArray)
            self?.bindDayOfWeek(dayOfWeek: $0)
        }
        .disposed(by: disposeBag)
    }
    
    /// 서버의 Response값을 토대로 ON/OFF 요일 표시
    func bindDayOfWeek(dayOfWeek: [Int]) {
        for element in dayOfWeek {
            switch element {
            case 0:
                mondayButton.backgroundColor = .primary500
            case 1:
                tuesdayButton.backgroundColor = .primary500
            case 2:
                wednesdayButton.backgroundColor = .primary500
            case 3:
                thursdayButton.backgroundColor = .primary500
            case 4:
                fridayButton.backgroundColor = .primary500
            case 5:
                saturdayButton.backgroundColor = .primary500
            case 6:
                sundayButton.backgroundColor = .primary500
            default:
                break
            }
        }
        
        let everyday = isSequentialDaysOfWeek(dayOfWeek: dayOfWeek)
        everydayButton.backgroundColor = everyday ? .primary500 : .gray200
    }
    
    /// 서버의 Response값이 [0, 1, 2, 3, 4, 5, 6] 일때 '매일' 버튼도 활성화
    /// - Parameter dayOfWeek: 서버의 Reponse값
    /// - Returns: [0, 1, 2, 3, 4, 5, 6] => true / [0, 1, 2, 3, 4, 5, 6]이 아니면 => false
    func isSequentialDaysOfWeek(dayOfWeek: [Int]) -> Bool {
        let expectedSet: Set<Int> = [0, 1, 2, 3, 4, 5, 6]
        let inputSet = Set(dayOfWeek)
        return expectedSet == inputSet
    }
}
