//
//  UIImagePickerController+Rx.swift
//  HappyMoodBoard
//
//  Created by 홍다희 on 2024/01/02.
//

import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: UIImagePickerController {
    
    public var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey: Any]> {
        return RxImagePickerProxy.proxy(for: base)
            .didFinishPickingMediaWithInfoSubject
            .asObservable()
            .do(onCompleted: {
                self.base.dismiss(animated: true, completion: nil)
            })
    }
    
    public var didCancel: Observable<Void> {
        return RxImagePickerProxy.proxy(for: base)
            .didCancelSubject
            .asObservable()
            .do(onCompleted: {
                self.base.dismiss(animated: true, completion: nil)
            })
    }
    
}

public typealias ImagePickerDelegate = UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension UIImagePickerController: HasDelegate {
    public typealias Delegate = ImagePickerDelegate
}

class RxImagePickerProxy: DelegateProxy<UIImagePickerController, ImagePickerDelegate>, DelegateProxyType, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public init(imagePicker: UIImagePickerController) {
        super.init(parentObject: imagePicker, delegateProxy: RxImagePickerProxy.self)
    }
    
    // MARK: - DelegateProxyType
    
    public static func registerKnownImplementations() {
        self.register { RxImagePickerProxy(imagePicker: $0) }
    }
    
    static func currentDelegate(for object: UIImagePickerController) -> ImagePickerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: ImagePickerDelegate?, to object: UIImagePickerController) {
        object.delegate = delegate
    }
    
    // MARK: - Proxy Subject
    
    internal lazy var didFinishPickingMediaWithInfoSubject = PublishSubject<[UIImagePickerController.InfoKey: Any]>()
    internal lazy var didCancelSubject = PublishSubject<Void>()
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        didFinishPickingMediaWithInfoSubject.onNext(info)
        didFinishPickingMediaWithInfoSubject.onCompleted()
        didCancelSubject.onCompleted()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        didCancelSubject.onNext(())
        didCancelSubject.onCompleted()
        didFinishPickingMediaWithInfoSubject.onCompleted()
    }
    
    // MARK: - Completed
    
    deinit {
        self.didFinishPickingMediaWithInfoSubject.onCompleted()
        self.didCancelSubject.onCompleted()
    }
    
}
