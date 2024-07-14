//
//  ViewController.swift
//  PoketmonProfile
//
//  Created by 전성진 on 7/11/24.
//

import UIKit
import CoreData

class ManageController: UIViewController {
    
    var container: NSPersistentContainer!
    var mode: Mode = .create
    var name: String?
    var key: UUID?
    
    var manageView: ManageView!
    override func loadView() {
        super.loadView()
        manageViewConfigure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func manageViewConfigure() {
        manageView = ManageView(frame: self.view.frame)
        manageView.delegate = self
        self.view = manageView
        self.navigationItem.rightBarButtonItems = [manageView.saveButton]
        
        if mode == .create {
            self.title = "연락처 추가"
            fetchPokemonData()
        } else if let key = key, mode == .update {
            self.title = name
            profileSelectDataRead(key)
        }
    }
    
    // 제네릭으로 Decodable 프로토콜을 채택하는 타입만 받겠다고 선언
    private func fetchData<T: Decodable>(url: URL, completion: @escaping (T?) -> Void) {
        let session = URLSession(configuration: .default) // 기본 URLSession 설정으로 세션을 생성
        // URL 요청을 만들고, URLSession을 통해 데이터 작업을 시작
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            // 데이터가 없고 에러가 있으면 오류메세지 출력
            guard let data = data, error == nil else {
                print("데이터 로드 실패")
                completion(nil)
                return
            }
            // 범위
            let successRange = 200..<300
            // 처리코드가 범위에 맞는지 확인
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                // 데이터를 디코딩 후 실패하면 오류메세지 출력
                // try? 하면 실패하면 nil 반환
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    print("JSON 디코딩 실패")
                    completion(nil)
                    return
                }
                // 데이터를 클로저 매게변수로 전달
                completion(decodedData)
            } else {
                // 처리코드가 범위에 없을시 오류메세지 출력
                print("응답 오류")
                completion(nil)
            }
        }.resume()
    }
    
    private func fetchPokemonData() {
        
        let urlComponents = URLComponents(string: "https://pokeapi.co/api/v2/pokemon/\(Int.random(in: 1...1000))")
        
        guard let url = urlComponents?.url else {
            print("잘못된 URL")
            return
        }
        
        fetchData(url: url) { [weak self] (pokemon: Pokemon?) in
            // guard let 을 통해 self를 다시 강한참조를 하여 안전하게 사용
            guard let self, let pokemon else { return }
            // 메인 스레드로 설정을 해주지 않으면 백그라운드 스레드에서 돌아가서 안좋음
            guard let imageUrl = URL(string: pokemon.sprites.frontDefault) else { return }
            // image 를 로드하는 작업은 백그라운드 쓰레드 작업 : Data(contensOf:)
            if let data = try? Data(contentsOf: imageUrl) {
                if let image = UIImage(data: data) {
                    // 이미지뷰에 이미지를 그리는 작업은 UI 작업이기 때문에 다시 메인 쓰레드에서 작업.
                    DispatchQueue.main.async {
                        self.manageView.profileImageView.image = image
                    }
                }
            }
        }
    }
    
    private func delegateInit() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Core Data 스택을 쉽게 설정하고 관리할 수 있도록 해주는 객체 : persistentContainer
        self.container = appDelegate.persistentContainer
    }
    
    private func profileDataCreate() {
        delegateInit()
        // 생성
        guard let entity = NSEntityDescription.entity(forEntityName: PokemonProfile.className, in: self.container.viewContext) else { return }
        let newPokemonProfile = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        newPokemonProfile.setValue(manageView.nameTextField.text, forKey: PokemonProfile.Key.name)
        newPokemonProfile.setValue(manageView.phoneNumberTextField.text, forKey: PokemonProfile.Key.phoneNumber)
        newPokemonProfile.setValue(UUID(), forKey: PokemonProfile.Key.key)
        if let image = manageView.profileImageView.image {
            if let imageData = image.pngData() {
                newPokemonProfile.setValue(imageData, forKey: PokemonProfile.Key.profileImage)
            }
        }
        
        do {
            try self.container.viewContext.save()
            print("생성 성공")
        } catch {
            print("생성 실패")
        }
    }
    
    private func profileDataUpdate(_ key: UUID) {
        delegateInit()
        let request = PokemonProfile.fetchRequest()
        request.predicate = NSPredicate(format: "key == %@", key as CVarArg)
        
        do {
            let pokemonProfile = try self.container.viewContext.fetch(request)
            
            for profile in pokemonProfile as [NSManagedObject] {
                profile.setValue(manageView.nameTextField.text, forKey: PokemonProfile.Key.name)
                profile.setValue(manageView.phoneNumberTextField.text, forKey: PokemonProfile.Key.phoneNumber)
                if let image = manageView.profileImageView.image {
                    if let imageData = image.pngData() {
                        profile.setValue(imageData, forKey: PokemonProfile.Key.profileImage)
                    }
                }
            }
            
            try self.container.viewContext.save()
            
            print("수정 성공")
        } catch {
            print("수정 실패")
        }
    }
    
    private func profileSelectDataRead(_ key: UUID) {
        delegateInit()
        do {
            let request = PokemonProfile.fetchRequest()
            request.predicate = NSPredicate(format: "key == %@", key as CVarArg)
            // 속성으로 데이터 정렬해서 가져오기
            let pokemonProfile = try self.container.viewContext.fetch(request)
            
            for profile in pokemonProfile {
                manageView.nameTextField.text = profile.name
                manageView.phoneNumberTextField.text = profile.phoneNumber
                manageView.profileImageView.image = UIImage(data: profile.profileImage!)
            }
            
            print("조건 불러오기 성공")
        } catch {
            print("조건 불러오기 실패")
        }
    }
    
    func deleteData(_ key: UUID) {
        delegateInit()
        let request = PokemonProfile.fetchRequest()
        request.predicate = NSPredicate(format: "key == %@", key as CVarArg)
        
        do {
            let pokemonProfile = try self.container.viewContext.fetch(request)
            
            for profile in pokemonProfile as [NSManagedObject] {
                // data 중 name 의 값을 updateName 으로 update 한다.
                self.container.viewContext.delete(profile)
            }
            
            try self.container.viewContext.save()
            
            print("삭제 성공")
        } catch {
            print("삭제 실패")
        }
    }
    
    private func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        // 전화번호 형식을 정의한 정규식 패턴
        let regex = #"^\d{3}-\d{4}-\d{4}$"#
        // 일치하면 일치하는 부분을 리턴함 일치하는 부분이 없으면 nil return
        return phoneNumber.range(of: regex, options: .regularExpression) == nil
    }
}

protocol ManageViewDelegate {
    func manageViewPop()
    func fetchImage()
    func saveProfile()
}

extension ManageController: ManageViewDelegate {
    func manageViewPop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchImage() {
        fetchPokemonData()
    }
    
    func saveProfile() {
        if let phoneNumber = manageView.phoneNumberTextField.text, validatePhoneNumber(phoneNumber) {
            let alert = UIAlertController(title: "알림", message: "전화번호 형식을 확인해 주세요.\n(000-0000-0000)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
              return
            })
            self.present(alert, animated: true, completion: nil)
        } else {
            if mode == .create {
                profileDataCreate()
            } else if let key = key, mode == .update {
                profileDataUpdate(key)
            }
        }
    }
}

