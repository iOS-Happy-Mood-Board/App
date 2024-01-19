//
//  MyTabViewModel.swift
//  HappyMoodBoard
//
//  Created by ukBook on 1/18/24.
//

import Foundation

import RxSwift

final class MyTabViewModel: ViewModel {
    struct Input {
        let viewWillAppear: Observable<Void>
        let navigationRight: Observable<Void>
        let scrollViewDidScroll: Observable<Void>
    }
    
    struct Output {
        let viewWillAppear: Observable<Void>
        let navigationRight: Observable<Void>
        let username: Observable<String>
        let scrollViewDidScroll: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let username = input.viewWillAppear
            .flatMapLatest {
                ApiService()
                    .request(type: MyInformationResponse.self, target: MemberTarget.me)
                    .map { $0?.nickname ?? "" }
            }
        
//        input.viewWillAppear
//            .flatMapLatest {
//                ApiService()
//                    .request(type: <#T##Decodable.Protocol#>, target: <#T##TargetType#>)
//            }
        
        return Output(
            viewWillAppear: input.viewWillAppear,
            navigationRight: input.navigationRight,
            username: username,
            scrollViewDidScroll: input.scrollViewDidScroll
        )
    }
}

extension MyTabViewModel {
    
}
