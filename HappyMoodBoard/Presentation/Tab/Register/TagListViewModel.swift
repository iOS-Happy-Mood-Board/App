//
//  TagListViewModel.swift
//  HappyMoodBoard
//
//  Created by 홍다희 on 2024/01/09.
//

import Foundation

import RxSwift

final class TagListViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let editButtonTapped: Observable<Void>
        let itemSelected: Observable<Tag>
        let closeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let navigateToEdit: Observable<Void>
        let tags: Observable<[Tag]>
        let dismiss: Observable<Tag?>
    }
    
    func transform(input: Input) -> Output {
        let tags = input.viewWillAppear
            .flatMapLatest {
                ApiService()
                    .request(type: [Tag].self, target: TagTarget.fetch())
            }
            .map { $0 != nil ? $0! : [] }
            
        let dismiss = Observable<Tag?>.merge(
            input.itemSelected.map { tag -> Tag? in return tag },
            input.closeButtonTapped.map { _ -> Tag? in return nil }
        )
        return .init(
            navigateToEdit: input.editButtonTapped,
            tags: tags,
            dismiss: dismiss
        )
    }
    
}
