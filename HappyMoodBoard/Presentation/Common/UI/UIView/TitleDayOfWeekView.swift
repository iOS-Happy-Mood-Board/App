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
    let actionPublishSubject = PublishSubject<[Int]>()
    
    // TODO: 테스트 데이터 삭제 해야함
    let testArray = [1, 2, 3, 4, 5, 6, 7]
    
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
        let mondayButtonTapObservable = mondayButton.rx.tap.map { _ in return [1] }
        let tuesdayButtonTapObservable = tuesdayButton.rx.tap.map { _ in return [2] }
        let wednesdayButtonTapObservable = wednesdayButton.rx.tap.map { _ in return [3] }
        let thursdayButtonTapObservable = thursdayButton.rx.tap.map { _ in return [4] }
        let fridayButtonTapObservable = fridayButton.rx.tap.map { _ in return [5] }
        let saturdayButtonTapObservable = saturdayButton.rx.tap.map { _ in return [6] }
        let sundayButtonTapObservable = sundayButton.rx.tap.map { _ in return [7] }
        let everydayButtonTapObservable = everydayButton.rx.tap.map { _ in return [8] }
        
        dayOfWeekPublicSubject.bind { [weak self] in
            // TODO: 테스트 코드, 삭제
//            self?.bindDayOfWeek(dayOfWeek: self!.testArray)
            self?.bindDayOfWeek(dayOfWeek: $0)
        }
        .disposed(by: disposeBag)
        
        Observable.combineLatest(dayOfWeekPublicSubject, mondayButtonTapObservable)
            .map { r1, r2 in
                return self.mergeArrays(r1, r2)
            }
            .bind(to: actionPublishSubject)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(dayOfWeekPublicSubject, tuesdayButtonTapObservable)
            .map { r1, r2 in
                return self.mergeArrays(r1, r2)
            }
            .bind(to: actionPublishSubject)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(dayOfWeekPublicSubject, wednesdayButtonTapObservable)
            .map { r1, r2 in
                return self.mergeArrays(r1, r2)
            }
            .bind(to: actionPublishSubject)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(dayOfWeekPublicSubject, thursdayButtonTapObservable)
            .map { r1, r2 in
                return self.mergeArrays(r1, r2)
            }
            .bind(to: actionPublishSubject)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(dayOfWeekPublicSubject, saturdayButtonTapObservable)
            .map { r1, r2 in
                return self.mergeArrays(r1, r2)
            }
            .bind(to: actionPublishSubject)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(dayOfWeekPublicSubject, sundayButtonTapObservable)
            .map { r1, r2 in
                return self.mergeArrays(r1, r2)
            }
            .bind(to: actionPublishSubject)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(dayOfWeekPublicSubject, everydayButtonTapObservable)
//            .map { r1, r2 in
//                return self.mergeArrays(r1, r2)
//            }
//            .bind(to: actionPublishSubject)
//            .disposed(by: disposeBag)
    }
    
    /// 서버의 Response값을 토대로 ON/OFF 요일 표시
    func bindDayOfWeek(dayOfWeek: [Int]) {
        for element in dayOfWeek {
            switch element {
            case 1:
                mondayButton.backgroundColor = .primary500
            case 2:
                tuesdayButton.backgroundColor = .primary500
            case 3:
                wednesdayButton.backgroundColor = .primary500
            case 4:
                thursdayButton.backgroundColor = .primary500
            case 5:
                fridayButton.backgroundColor = .primary500
            case 6:
                saturdayButton.backgroundColor = .primary500
            case 7:
                sundayButton.backgroundColor = .primary500
            default:
                break
            }
        }
        
        let everyday = isSequentialDaysOfWeek(dayOfWeek: dayOfWeek)
        everydayButton.backgroundColor = everyday ? .primary500 : .gray200
    }
    
    /// 서버의 Response값이 [1, 2, 3, 4, 5, 6, 7] 일때 '매일' 버튼도 활성화
    /// - Parameter dayOfWeek: 서버의 Reponse값
    /// - Returns: [1, 2, 3, 4, 5, 6, 7] => true / [1, 2, 3, 4, 5, 6, 7]이 아니면 => false
    func isSequentialDaysOfWeek(dayOfWeek: [Int]) -> Bool {
        let expectedSet: Set<Int> = [1, 2, 3, 4, 5, 6, 7]
        let inputSet = Set(dayOfWeek)
        return expectedSet == inputSet
    }
    
    func mergeArrays(_ array1: [Int], _ array2: [Int]) -> [Int] {
        var resultArray = array1

        for element in array2 {
            if !resultArray.contains(element) {
                resultArray.append(element)
            } else {
                // 중복된 요소가 있을 경우 제거
                if let index = resultArray.firstIndex(of: element) {
                    resultArray.remove(at: index)
                }
            }
        }

        return resultArray.sorted()
    }
}
