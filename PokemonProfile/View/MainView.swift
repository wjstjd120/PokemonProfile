//
//  MainView.swift
//  PoketmonProfile
//
//  Created by 전성진 on 7/11/24.
//

import UIKit
import SnapKit

class MainView: UIView {
    
    var delegate: MainViewDelegate?
    
    // navigation bar button
    lazy var addButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "추가"
        barButton.tintColor = .systemGray
        barButton.target = self
        barButton.action = #selector(manageViewPush)
        
        return barButton
    }()
    
    let profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none // 회색줄 없애기
        
        return tableView
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
        
        [profileTableView].forEach {
            self.addSubview($0)
        }
        
        profileTableView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

extension MainView {
    @objc
    func manageViewPush() {
        delegate?.manageViewPush()
    }
}
