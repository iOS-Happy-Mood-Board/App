//
//  EditTagViewModel.swift
//  HappyMoodBoard
//
//  Created by 홍다희 on 2024/01/19.
//

import Foundation

import RxSwift

final class EditTagViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let completeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let items: Observable<[EditTagSection]>
    }
    
    func transform(input: Input) -> Output {
        let items = input.viewWillAppear
            .flatMapLatest {
                ApiService()
                    .request(type: [Tag].self, target: TagTarget.fetch())
            }
            .compactMap { [EditTagSection(header: "", items: $0 ?? [])] }
        
        return .init(
            items: items
        )
    }
    
}
