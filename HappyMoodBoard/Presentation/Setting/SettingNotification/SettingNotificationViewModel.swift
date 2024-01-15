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
    }
    
    struct Output {
        let navigateToBack: Observable<Void>
        let notificationSettings: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let notificationSettings = input.viewWillAppear
            .map {
                NotificationTarget.member
            }
            .flatMapLatest {
                ApiService().request(type: MemberResponse.self, target: $0)
            }
            .map {
                traceLog($0)
            }
        
        return Output(
            navigateToBack: input.navigateToBack,
            notificationSettings: notificationSettings
        )
    }
}
