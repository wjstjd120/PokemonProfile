//
//  ProfileTableCell.swift
//  PoketmonProfile
//
//  Created by 전성진 on 7/11/24.
//

import UIKit
import SnapKit

class ProfileTableCell: UITableViewCell {
    static let cellId =  "profileTableCell"
    
    var key: UUID?
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBackground
        imageView.layer.cornerRadius = 30
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "전성진"
        label.font = .systemFont(ofSize: 15)
        
        return label
    }()
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "010-0000-0000"
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        [profileImageView, nameLabel, phoneNumberLabel].forEach {
            self.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.left.equalToSuperview().offset(30)
            $0.height.equalTo(profileImageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints {
            $0.left.equalTo(profileImageView.snp.right).offset(20)
            $0.centerY.equalToSuperview()
        }
        
        phoneNumberLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-30)
            $0.centerY.equalToSuperview()
        }
    }
}
