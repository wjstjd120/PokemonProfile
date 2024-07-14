//
//  ViewController.swift
//  PoketmonProfile
//
//  Created by 전성진 on 7/11/24.
//

import UIKit
import CoreData

class MainController: UIViewController {
    
    var container: NSPersistentContainer!
    var list: [PokemonProfile] = []
    var mainView: MainView!
    
    override func loadView() {
        super.loadView()
        mainViewConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //뷰가 로드되기 직전 데이터 가져옴
        profileAllDataRead()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate // 타입 캐스팅을 해서 AppDelegate 불러옴
        self.container = appDelegate.persistentContainer
    }
    
    private func mainViewConfigure() {
        mainView = MainView(frame: self.view.frame)
        mainView.profileTableView.register(ProfileTableCell.self, forCellReuseIdentifier: ProfileTableCell.cellId)
        mainView.profileTableView.delegate = self
        mainView.profileTableView.dataSource = self
        mainView.delegate = self
        self.view = mainView
        self.title = "친구 목록"
        self.navigationItem.backButtonTitle = "Back"
        self.navigationItem.rightBarButtonItems = [mainView.addButton]
    }
    
    private func profileAllDataRead() {
        do {
            let request = PokemonProfile.fetchRequest()
            // 속성으로 데이터 정렬해서 가져오기
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            let pokemonProfile = try self.container.viewContext.fetch(request)
            list = pokemonProfile
            mainView.profileTableView.reloadData()
            
            print("리스트 불러오기 성공")
        } catch {
            print("리스트 불러오기 실패")
        }
    }
}

extension MainController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableCell.cellId, for: indexPath) as? ProfileTableCell else {
            return UITableViewCell()
        }
        cell.nameLabel.text = list[indexPath.item].name
        cell.phoneNumberLabel.text = list[indexPath.item].phoneNumber
        cell.profileImageView.image = UIImage(data: list[indexPath.item].profileImage!)
        cell.key = list[indexPath.item].key
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ProfileTableCell {
            let manageController = ManageController()
            manageController.key = cell.key
            manageController.name = cell.nameLabel.text ?? nil
            manageController.mode = .update
            self.navigationController?.pushViewController(manageController, animated: true)
        }
        mainView.profileTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "삭제", message: "삭제 하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "취소", style: .default) { _ in
              return
            })
            alert.addAction(UIAlertAction(title: "확인", style: .default) { [self] _ in
                let manageController = ManageController()
                manageController.deleteData(list[indexPath.item].key!)
                list.remove(at: indexPath.item)
//                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .fade)
//                tableView.layoutIfNeeded()
//                tableView.endUpdates()
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
}

protocol MainViewDelegate {
    func manageViewPush()
}

extension MainController: MainViewDelegate {
    func manageViewPush() {
        let manageController = ManageController()
        self.navigationController?.pushViewController(manageController, animated: true)
    }
}
