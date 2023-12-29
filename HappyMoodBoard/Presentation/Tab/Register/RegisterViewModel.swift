//
//  RegisterViewModel.swift
//  HappyMoodBoard
//
//  Created by 홍다희 on 2023/12/27.
//

import Foundation

import RxSwift

final class RegisterViewModel: ViewModel {
    
    struct Input {
        let textChanged: Observable<String?>
        let backTrigger: Observable<Void>
        let saveTrigger: Observable<Void>
        let cameraTrigger: Observable<Void>
        let tagTrigger: Observable<Void>
        let keyboardTrigger: Observable<Void>
    }
    
    struct Output {
        let canSave: Observable<Bool>
        let navigateToBack: Observable<Void>
        let showAlert: Observable<Void>
        let camera: Observable<Void>
        let tag: Observable<Void>
        let keyboard: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        // input.backTrigger && isValid 일 경우 showAlert
        // 아닐 경우 바로 navigateToBack
        return .init(
            canSave: .just(true),
            navigateToBack: input.backTrigger,
            showAlert: input.backTrigger,
            camera: input.cameraTrigger,
            tag: input.tagTrigger,
            keyboard: input.keyboardTrigger
        )
    }
    
}
