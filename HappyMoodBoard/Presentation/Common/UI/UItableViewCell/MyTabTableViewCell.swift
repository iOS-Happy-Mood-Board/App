//
//  MyTabTableViewCell.swift
//  HappyMoodBoard
//
//  Created by ukBook on 1/21/24.
//

import UIKit
import SnapKit
import Then

class MyTabTableViewCell: UITableViewCell {
    // 셀 내부의 요소들을 정의합니다.
    
    let createdAtLabel = UILabel().then {
        $0.textColor = .primary900
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: "Pretendard-Regular", size: 16)
        $0.numberOfLines = 0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSelf()
        setupSubviews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0))
    }
    
    func setupSelf() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.primary600?.cgColor
        contentView.layer.cornerRadius = 15
    }
    
    func setupSubviews() {
        [
            createdAtLabel,
            titleLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    func setupLayouts() {
        createdAtLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(createdAtLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(createdAtLabel)
            $0.bottom.equalTo(-24)
        }
    }
    
    /// Cell Bind 함수
    /// - Parameter tuple: (생성일자, 게시글 내용, 이미지 path)
    func bindData(tuple: (String, String, String)) {
        traceLog(tuple)
        
        self.createdAtLabel.text = convertDateString(tuple.0) ?? "9999/99/99"
        self.titleLabel.text = tuple.1
    }
}

