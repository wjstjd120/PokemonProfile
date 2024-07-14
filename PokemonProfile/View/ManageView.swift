//
//  MainView.swift
//  PoketmonProfile
//
//  Created by 전성진 on 7/11/24.
//

import UIKit
import SnapKit

class ManageView: UIView {
    
    var delegate: ManageViewDelegate?
    
    var key: UUID?
    
    // navigation bar button
    lazy var saveButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "적용"
        barButton.tintColor = .systemBlue
        barButton.target = self
        barButton.action = #selector(saveProfile)
        
        return barButton
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBackground
        imageView.layer.cornerRadius = 80
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var randomImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addAction(UIAction{ _ in
            // API로직
            self.delegate?.fetchImage()
        }, for: .touchUpInside)
        
        return button
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.addLeftPadding()
        
        return textField
    }()
    
    let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.addLeftPadding()

        return textField
    }()
    
    let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureUI() {
        self.backgroundColor = .systemBackground
        [profileImageView, randomImageButton, textFieldStackView].forEach {
            self.addSubview($0)
        }
        
        [nameTextField, phoneNumberTextField].forEach {
            textFieldStackView.addArrangedSubview($0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.height.width.equalTo(160)
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        randomImageButton.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.centerX.equalTo(profileImageView.snp.centerX)
        }
        
        textFieldStackView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.left.right.equalToSuperview().inset(20)
            $0.top.equalTo(randomImageButton.snp.bottom).offset(30)
        }
    }
}

extension ManageView {
    @objc
    func saveProfile() {
        delegate?.saveProfile()
        delegate?.manageViewPop()
    }
}

extension UITextField {
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
}
