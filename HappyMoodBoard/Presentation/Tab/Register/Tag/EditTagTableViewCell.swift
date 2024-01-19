//
//  EditTagTableViewCell.swift
//  HappyMoodBoard
//
//  Created by 홍다희 on 2024/01/19.
//

import UIKit

import Then
import SnapKit

import RxSwift
import RxCocoa

final class EditTagTableViewCell: UITableViewCell {

    static let reuseIdentifier = "EditTagTableViewCell"
    
    let contentStackView: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 24
        let verticalInset: CGFloat = 8
        let horizontalInset: CGFloat = 24
        $0.layoutMargins = .init(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    let deleteButton: UIButton = .systemButton(with: .remove, target: nil, action: nil).then {
        $0.tintColor = .red
        $0.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
    }
    
    let nameLabel: UILabel = .init().then {
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
    }
    
    let editButton: UIButton = .systemButton(with: .init(named: "navigation.edit")!, target: nil, action: nil).then {
        $0.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        contentView.addSubview(contentStackView)
        
        [
            deleteButton,
            nameLabel,
            editButton
        ].forEach { contentStackView.addArrangedSubview($0) }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
