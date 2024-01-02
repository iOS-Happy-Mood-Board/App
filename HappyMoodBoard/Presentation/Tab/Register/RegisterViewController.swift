//
//  RegisterViewController.swift
//  HappyMoodBoard
//
//  Created by 홍다희 on 2023/12/20.
//

import UIKit
import Photos

import Then
import SnapKit

import RxSwift
import RxCocoa

final class RegisterViewController: UIViewController {
    
    private let backButton: UIBarButtonItem = .init(
        image: .init(named: "navigation.back"),
        style: .plain,
        target: nil,
        action: nil
    )
    
    private let registerButton: UIBarButtonItem = .init(
        image: .init(named: "navigation.register.normal"),
        style: .done,
        target: nil,
        action: nil
    )
    
    private let headerLabel: UILabel = .init().then {
        $0.text = "오늘의 행복은 어떤건가요?"
        $0.textColor = .gray900
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    private let contentStackView: UIStackView = .init().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 40
    }
    
    private let imageView: UIImageView = .init().then {
        $0.isHidden = true
        $0.contentMode = .scaleAspectFit
        $0.layer.backgroundColor = UIColor.primary200?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.primary500?.cgColor
    }
    
    private let deleteButton: UIButton = .init().then {
        $0.setImage(UIImage(named: "delete"), for: .normal)
    }
    
    private let tagButton: UIButton = .init(type: .system).then {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        let verticalInset: CGFloat = 4.5
        let horizontalInset: CGFloat = 18.5
        configuration.contentInsets = .init(
            top: verticalInset,
            leading: horizontalInset,
            bottom: verticalInset,
            trailing: horizontalInset
        )
        configuration.image = .init(named: "tag.delete")
        configuration.imagePadding = 10
        configuration.imagePlacement = .trailing
        $0.configuration = configuration
    }
    
    private let textView: UITextView = .init().then {
        $0.text = nil // "최대 1000자까지 작성 가능해요."
        $0.textColor = .gray700
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.primary900?.cgColor
        $0.textContainerInset = .init(top: 24, left: 24, bottom: 24, right: 24)
    }
    
    private let cameraButton: UIBarButtonItem = .init(
        image: .init(named: "toolbar.camera"),
        style: .plain,
        target: nil,
        action: nil
    )
    
    private let tagBarButton: UIBarButtonItem = .init(
        image: .init(named: "toolbar.tag"),
        style: .plain,
        target: nil,
        action: nil
    )
    
    private let keyboardButton: UIBarButtonItem = .init(
        image: .init(named: "toolbar.keyboard.up"),
        style: .plain,
        target: nil,
        action: nil
    )
    
    private let imagePicker: UIImagePickerController = .init()
    
    private lazy var toolbar: UIToolbar = .init().then {
        $0.items = [cameraButton, tagBarButton, .flexibleSpace(), keyboardButton]
        $0.barTintColor = .primary100
    }
    
    private let viewModel: RegisterViewModel = .init()
    private let disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCommonBackgroundColor()
        setupNavigationBar()
        setupSubviews()
        setupLayouts()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
}

extension RegisterViewController: ViewAttributes {
    
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = registerButton
    }
    
    func setupSubviews() {
        [
            headerLabel,
            contentStackView,
            toolbar,
            deleteButton
        ].forEach { view.addSubview($0) }
        
        [
            imageView,
            tagButton,
            textView
        ].forEach { contentStackView.addArrangedSubview($0) }
    }
    
    func setupLayouts() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(216)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(imageView).inset(8)
        }
        
        toolbar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(52)
        }
    }
    
    func setupBindings() {
        let input = RegisterViewModel.Input(
            textChanged: textView.rx.text.asObservable(),
            backButtonTapped: backButton.rx.tap.asObservable(),
            saveButtonTapped: registerButton.rx.tap.asObservable(),
            cameraButtonTapped: cameraButton.rx.tap.asObservable(),
            tagBarButtonTapped: tagBarButton.rx.tap.asObservable(),
            keyboardButtonTapped: keyboardButton.rx.tap.asObservable(),
            keyboardWillShow: NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification),
            imageSelected: imagePicker.rx.didFinishPickingMediaWithInfo.asObservable()
        )
        let output = viewModel.transform(input: input)
        output.canRegister
            .withUnretained(self)
            .subscribe(onNext: { owner, isEnabled in
                let normalImage: UIImage = .init(named: "navigation.register.normal") ?? .init()
                let disabledImage: UIImage = .init(named: "navigation.register.disabled") ?? .init()
                owner.registerButton.image = isEnabled ? normalImage : disabledImage
            })
            .disposed(by: disposeBag)
        
        output.navigateToBack
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: false)
            })
            .disposed(by: disposeBag)
        
        output.showImagePicker
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.requestPhotoLibraryAuthorization()
            })
            .disposed(by: disposeBag)
        
        output.image
            .withUnretained(self)
            .debug()
            .subscribe(onNext: { onwer, image in
                let inset: CGFloat = 16
                let edgeInsets: UIEdgeInsets = .init(top: -inset, left: -inset, bottom: -inset, right: -inset)
                onwer.imageView.image = image?.withAlignmentRectInsets(edgeInsets)
                onwer.imageView.isHidden = image == nil
            })
            .disposed(by: disposeBag)
        
        output.tag
            .withUnretained(self)
            .subscribe { owner, tag in
                guard let tag = tag else {
                    owner.tagButton.isHidden = true
                    return
                }
                var configuration = owner.tagButton.configuration
                var container = AttributeContainer()
                container.font = UIFont(name: "Pretendard-Medium", size: 14)
                configuration?.attributedTitle = AttributedString(tag.name, attributes: container)
                configuration?.baseBackgroundColor = .init(hexString: tag.color)
                configuration?.baseForegroundColor = .gray700
                owner.tagButton.configuration = configuration
                owner.tagButton.isHidden = false
            }
            .disposed(by: disposeBag)
    }
    
}

extension RegisterViewController {
    
    func showImagePickerSourceTypeSelectionAlert() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.showImagePickerController(for: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.requestPhotoLibraryAuthorization()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func requestPhotoLibraryAuthorization() {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .notDetermined, .restricted:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    DispatchQueue.main.async { [weak self] in
                        self?.showImagePickerController(for: .photoLibrary)
                    }
                }
            }
        case .denied:
            DispatchQueue.main.async { [weak self] in
                self?.showPhotoLibraryAuthorizationAlert()
            }
        case .authorized, .limited:
            DispatchQueue.main.async { [weak self] in
                self?.showImagePickerController(for: .photoLibrary)
            }
        @unknown default: break
        }
    }
    
    func showImagePickerController(for sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: nil, message: "\(sourceType)에 접근할 수 없습니다", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func showPhotoLibraryAuthorizationAlert() {
        let viewController = PhotoLibraryAuthorizationViewController()
        viewController.sheetPresentationController?.detents = [.medium()]
        viewController.sheetPresentationController?.prefersGrabberVisible = true
        present(viewController, animated: true, completion: nil)
    }
    
}
