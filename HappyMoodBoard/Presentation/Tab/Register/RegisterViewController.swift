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
        image: .init(named: "navigation.register.disabled"),
        style: .done,
        target: nil,
        action: nil
    ).then {
        $0.setBackgroundImage(.init(named: "navigation.register.normal"), for: .normal, barMetrics: .default)
        $0.setBackgroundImage(.init(named: "navigation.register.disabled"), for: .disabled, barMetrics: .default)
    }
    
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
    }
    
    private let tagLabel: UILabel = .init().then {
        $0.text = "휴식"
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 15, weight: .bold)
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
    
    private let tagButton: UIBarButtonItem = .init(
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
    
    private lazy var toolbar: UIToolbar = .init().then {
        $0.items = [cameraButton, tagButton, .flexibleSpace(), keyboardButton]
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
            toolbar
        ].forEach { view.addSubview($0) }
        
        [
            imageView,
            tagLabel,
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
            make.width.height.equalTo(200)
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
            backTrigger: backButton.rx.tap.asObservable(),
            saveTrigger: registerButton.rx.tap.asObservable(),
            cameraTrigger: cameraButton.rx.tap.asObservable(),
            tagTrigger: tagButton.rx.tap.asObservable(),
            keyboardTrigger: keyboardButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        output.camera
            .subscribe(onNext: { [weak self] in
                // self?.showCameraAlert()
                self?.openGallery()
            })
            .disposed(by: disposeBag)
        output.navigateToBack
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: false)
            })
            .disposed(by: disposeBag)
    }
    
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showCameraAlert() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            requestPhotoLibraryAuthorization()
        } else {
            let alert = UIAlertController(
                title: "Warning",
                message: "You don't have permission to access gallery.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func requestPhotoLibraryAuthorization() {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .notDetermined, .restricted:
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    DispatchQueue.main.async { [weak self] in
                        self?.showImagePickerController()
                    }
                }
            }
        case .denied:
            // TODO: 허용 안 함 > 바텀시트 노출 > [설정 변경하러 가기] 클릭 시, 유저 기기 내 Bee Happy 설정 화면으로 이동 > 사진 접근 변동 시 앱 내 반영
            // TODO: [설정 변경하러 가기] 미선택 시 등록 기본 화면(home/create)로 이동 > 사진 다시 클릭 시 동의 여부 재노출
            
            print(".denied")
            DispatchQueue.main.async { [weak self] in
                self?.showPhotoLibraryAuthorizationAlert()
            }
        case .authorized, .limited:
            DispatchQueue.main.async { [weak self] in
                self?.showImagePickerController()
            }
        @unknown default:
            print()
        }
    }
    
    func showImagePickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showPhotoLibraryAuthorizationAlert() {
        let viewController = PhotoLibraryAuthorizationViewController()
        viewController.sheetPresentationController?.detents = [.medium()]
        viewController.sheetPresentationController?.prefersGrabberVisible = true
        present(viewController, animated: true, completion: nil)
    }
    
    private func displayImage(_ image: UIImage?) {
        imageView.image = image
        imageView.isHidden = false
    }
    
    private func displayEmptyImage() {
        imageView.image = nil
        imageView.isHidden = true
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let image = info[.editedImage] as? UIImage {
            displayImage(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
