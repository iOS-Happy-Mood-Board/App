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
        let viewWillAppear: Observable<Bool>
        let navigateToBack: Observable<Void>
    }
    
    struct Output {
        let systemNotification: Observable<Bool>
        let navigateToBack: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let pushNotification = input.viewWillAppear
            .flatMap { _ in
                return isSystemNotificationEnabled()
            }
        
        return Output(
            systemNotification: pushNotification,
            navigateToBack: input.navigateToBack
        )
    }
}

func isSystemNotificationEnabled() -> Observable<Bool> {
    return Observable.create { observer in
        let center = NotificationCenter.default
        let notificationObserver = center.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil) { _ in
            let isEnabled = UIApplication.shared.currentUserNotificationSettings?.types != []
            observer.onNext(isEnabled)
        }

        // Initial check for notification status
        let isEnabled = UIApplication.shared.currentUserNotificationSettings?.types != []
        observer.onNext(isEnabled)

        return Disposables.create {
            center.removeObserver(notificationObserver)
        }
    }
}
