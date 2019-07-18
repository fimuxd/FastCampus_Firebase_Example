//
//  EnterViewController.swift
//  FastCampusFirebaseExample
//
//  Created by Boyoung Park on 21/04/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAnalytics

class EnterViewController: UIViewController {
    var ref: DatabaseReference!
    var remoteConfig: RemoteConfig!
    
    @IBOutlet weak var helloTextLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        remoteConfigSetting()
        self.attribute()
    }
    
    private func attribute() {
        [nameTextField, birthdayTextField, emailTextField]
            .forEach { $0?.delegate = self }
        self.nameTextField.becomeFirstResponder()
        self.enterButton.isEnabled = false
    }
    
    @IBAction func enterButtonTapped(_ sender: UIButton) {
        self.saveUserInfo()
        Analytics.logEvent("입력하기_버튼_클릭", parameters: nil)
    }
    
    private func saveUserInfo() {
        //MARK: Firebase Database에 새로운 내용을 입력합니다.
        guard let name = nameTextField.text,
            let email = emailTextField.text else {
            return
        }
        let birthday = birthdayTextField.text ?? ""
        
        let userInfo = [
            "name": name,
            "birthday": birthday,
            "email": email
        ]
        
        self.ref
            .child("users")
            .childByAutoId()
            .setValue(userInfo) { [weak self] error, _ in
                if let `error` = error {
                    presentAlert(base: self, type: .submitFailed(error: error))
                } else {
                    self?.statusLabel.text = "데이터가 성공적으로 저장되었습니다."
                }
            }
    }
}

extension EnterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let nameTextFilled = self.nameTextField.text != ""
        let emailTextFilled = self.emailTextField.text != ""
        self.enterButton.isEnabled = nameTextFilled && emailTextFilled
    }
}

extension EnterViewController {
    enum Configuration: String {
        case helloTextHidden = "hello_text_hidden"
        case helloText = "hello_text"
    }
    
    private func remoteConfigSetting() {
        self.remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        remoteConfig.configSettings = settings
        fetchConfig()
    }
    
    private func fetchConfig() {
        self.helloTextLabel.isHidden = isHelloTextLabelHidden()
        self.helloTextLabel.text = getHelloText()
        
        // 캐시된 데이터를 버리고 다시 불러오는 데 걸리는 시간
        let expirationDuration: Int = 0
        remoteConfig
            .fetch(withExpirationDuration: TimeInterval(expirationDuration)) { [weak self] (status, error) -> Void in
                if status == .success {
                    self?.remoteConfig.activateFetched()
                } else {
                    print("Config not fetched")
                    print("Error \(error!.localizedDescription)")
                }
        }
    }
    
    private func isHelloTextLabelHidden() -> Bool {
        guard let isHiddenText = remoteConfig[Configuration.helloTextHidden.rawValue].stringValue,
            let isHidden = Bool(isHiddenText) else {
                return true
        }
        
        return isHidden
    }
    
    private func getHelloText() -> String {
        guard let helloText = remoteConfig[Configuration.helloText.rawValue].stringValue else {
            return "안녕하세요"
        }
        
        return helloText
    }
}
