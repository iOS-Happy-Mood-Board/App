//
//  EditTagViewController.swift
//  HappyMoodBoard
//
//  Created by 홍다희 on 2024/01/19.
//

import UIKit

import Then
import SnapKit

import RxSwift
import RxCocoa
import RxDataSources

final class EditTagViewController: UIViewController {
    
    private let tableView: UITableView = .init().then {
        $0.register(EditTagTableViewCell.self, forCellReuseIdentifier: EditTagTableViewCell.reuseIdentifier)
        $0.backgroundColor = .clear
        $0.isEditing = true
        $0.separatorStyle = .none
    }
    
    private let completeButton = UIButton(type: .system).then {
        $0.configurationUpdateHandler = { button in
            var container = AttributeContainer()
            container.font = UIFont(name: "Pretendard-Medium", size: 18)
            container.foregroundColor = button.isEnabled ? .gray900 : .gray400
            var configuration = UIButton.Configuration.filled()
            configuration.cornerStyle = .capsule
            configuration.background.backgroundColor = button.isEnabled ? .primary500 : .gray200
            configuration.attributedTitle = AttributedString("편집 완료", attributes: container)
            button.configuration = configuration
        }
    }
    
    private let viewModel: EditTagViewModel = .init()
    private let disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCommonBackgroundColor()
        setupNavigationBar()
        setupSubviews()
        setupLayouts()
        setupBindings()
    }
    
}

extension EditTagViewController: ViewAttributes {
    func setupNavigationBar() {
        navigationItem.title = "태그 편집"
    }
    
    func setupSubviews() {
        [
            tableView,
            completeButton
        ].forEach { view.addSubview($0) }
    }
    
    func setupLayouts() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            make.leading.trailing.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-26)
            make.height.equalTo(52)
        }
    }
    
    func setupBindings() {
        let dataSource = RxTableViewSectionedAnimatedDataSource<EditTagSection>(
            configureCell: { ds, tv, _, item in
                guard let cell = tv.dequeueReusableCell(
                    withIdentifier: EditTagTableViewCell.reuseIdentifier
                ) as? EditTagTableViewCell else {
                    return .init()
                }
                cell.nameLabel.text = item.tagName
                return cell
            },
            titleForHeaderInSection: { ds, index in
                ds.sectionModels[index].header
            }
        )
        let input = EditTagViewModel.Input(
            viewWillAppear: rx.viewWillAppear.asObservable(),
            completeButtonTapped: completeButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        output.items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - UITableViewDelegate

extension EditTagViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        48
    }
    
}
