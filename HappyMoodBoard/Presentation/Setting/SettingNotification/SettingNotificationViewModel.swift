//
//  SettingNotificationViewModel.swift
//  HappyMoodBoard
//
//  Created by ukseung.dev on 1/5/24.
//

import Foundation

import RxSwift

final class SettingNotificationViewModel: ViewModel {
    struct Input {
        let navigateToBack: Observable<Void>
        let viewWillAppear: Observable<Void>
        let recordPush: Observable<Bool>
        let marketingPush: Observable<Bool>
    }
    
    struct Output {
        let navigateToBack: Observable<Void>
//        let notificationSettings: Observable<MemberResponse?>
        let happyItemActive: Observable<Bool>
        let dayOfWeek: Observable<[Int]>
        let time: Observable<String>
        let marketingActive: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {

        // MARK: /api/notification/v1/member, 알림 설정 조회
        let notificationSettings: Observable<MemberResponse?> = input.viewWillAppear
            .map {
                NotificationTarget.member
            }
            .flatMapLatest {
                ApiService().request(type: MemberResponse.self, target: $0)
            }
            .share()
        
        // MARK: - 행복아이템 기록 알림 받기
        let happyItemActive = notificationSettings
            .filter {
                $0 != nil
            }
            .compactMap {
                $0?.happyItem.active
            }

        // MARK: - 요일
        let dayOfWeek = notificationSettings
            .filter {
                $0 != nil
            }
            .compactMap {
                $0?.happyItem.dayOfWeek
            }
        
        // MARK: - 시간
        let time = notificationSettings
            .filter {
                $0 != nil
            }
            .compactMap {
                $0?.happyItem.time
            }
            .compactMap {
                // MARK: - dateFormat Error 처리
                self.convert24HourTo12HourFormat(timeString: $0)
            }
        
        // MARK: - 마케팅 동의 알림
        let marketingActive = notificationSettings
            .filter {
                $0 != nil
            }
            .compactMap {
                $0?.marketing.active
            }
            
        return Output(
            navigateToBack: input.navigateToBack,
            happyItemActive: happyItemActive,
            dayOfWeek: dayOfWeek,
            time: time,
            marketingActive: marketingActive
        )
    }
}

extension SettingNotificationViewModel {
    func convert24HourTo12HourFormat(timeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        guard let date = dateFormatter.date(from: timeString) else {
            return nil
        }

        let twelveHourFormat = DateFormatter()
        twelveHourFormat.locale = Locale(identifier: "ko_KR")
        twelveHourFormat.dateFormat = "a hh:mm"
        
        return twelveHourFormat.string(from: date)
    }
}
