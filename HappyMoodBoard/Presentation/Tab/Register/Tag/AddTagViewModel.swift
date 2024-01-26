//
//  AddTagViewModel.swift
//  HappyMoodBoard
//
//  Created by 홍다희 on 2024/01/16.
//

import Foundation

import RxSwift

final class AddTagViewModel: ViewModel {
    
    struct Input {
        let name: Observable<String>
        let completeButtonTapped: Observable<Void>
        let colorButtonTapped: Observable<Int>
    }
    
    struct Output {
        let tag: Observable<Tag>
        let dismiss: Observable<Void>
        let errorMessage: Observable<String>
    }
    
    private let tag: Tag
    
    init(tag: Tag = .init()) {
        self.tag = tag
    }
    
    func transform(input: Input) -> Output {
        let nameAndColor = Observable.combineLatest(
            input.name,
            input.colorButtonTapped
        )
        
        let tag = Observable.combineLatest(Observable.just(self.tag), nameAndColor) { (tag, nameAndColor) -> Tag in
            return Tag(id: tag.id, tagName: nameAndColor.0, tagColorId: nameAndColor.1)
        }
            .startWith(self.tag)
            .share()
        
        let result = input.completeButtonTapped.withLatestFrom(tag)
            .map { UpdatePostTagParameters(tagId: $0.id, tagName: $0.tagName ?? "", tagColorId: $0.tagColorId) }
            .flatMapLatest { parameter -> Observable<Event<PostTagResponse?>> in
                if parameter.tagId == nil {
                    // 태그 생성
                    return ApiService()
                        .request(type: PostTagResponse.self, target: TagTarget.create(parameter))
                        .materialize()
                } else {
                    // 태그 편집
                    return ApiService()
                        .request(type: PostTagResponse.self, target: TagTarget.update(parameter))
                        .materialize()
                }
            }
            .share()
        
        let success = result.elements()
            .map { _ in Void() }
        
        let failure = result.errors()
            .map { $0.localizedDescription }
        
        return .init(
            tag: tag,
            dismiss: success,
            errorMessage: failure
        )
    }
    
}
