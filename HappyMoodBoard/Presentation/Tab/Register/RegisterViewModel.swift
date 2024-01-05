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
        let backButtonTapped: Observable<Void>
        let registerButtonTapped: Observable<Void>
        let deleteImageAlertActionTapped: Observable<Int>
        let addImageButtonTapped: Observable<Void>
        let addTagButtonTapped: Observable<Void>
        let keyboardButtonTapped: Observable<Void>
        let keyboardWillShow: Observable<Notification>
        let imageSelected: Observable<[UIImagePickerController.InfoKey: Any]>
    }
    
    struct Output {
        let canRegister: Observable<Bool>
        let navigateToBack: Observable<Void>
        let showAlert: Observable<Void>
        let showImagePicker: Observable<Void>
        let image: Observable<UIImage?>
        let tag: Observable<Tag?>
        let keyboard: Observable<Void>
    }
    
    func transform(input: Input) -> Output {
        let image = Observable.merge(
            input.imageSelected
                .map { $0[.editedImage] as? UIImage },
            input.deleteImageAlertActionTapped
                .filter { $0 == 1 }
                .map { _ in nil }
        )
            .share()
            
        let text = input.textChanged
        let sampleTag: Tag? = Tag(name: "휴식", color: "#FFC895")
        let tag = Observable.just(sampleTag)
        
        // TODO: '뒤로가기' 눌렀을 때, 글씨, 이미지 등록, 태그 등록 중 1가지라도 되어있을 경우 -> "작성한 내용이 저장되지 않아요.\n정말 뒤로 가시겠어요?" 팝업 노출
        
        let textValid = text
            .map(checkTextValid)
            .startWith(false)
            .distinctUntilChanged()
        
        let imageValid = image
            .map(checkImageValid)
            .startWith(false)
            .distinctUntilChanged()
        
        // 본문이 1글자 이상 존재하거나 사진이 1개 등록인 상태일 경우
        // 발행 버튼 활성화
        let canRegister = Observable.combineLatest(textValid, imageValid) { $0 || $1 }
        
        return .init(
            canRegister: canRegister,
            navigateToBack: input.backButtonTapped,
            showAlert: input.backButtonTapped,
            showImagePicker: input.addImageButtonTapped,
            image: image,
            tag: tag,
            keyboard: input.keyboardButtonTapped
        )
    }
    
    private func checkTextValid(_ text: String?) -> Bool {
        (text ?? "").count > 0
    }
    
    private func checkImageValid(_ image: UIImage?) -> Bool {
        image != nil
    }
    
}
