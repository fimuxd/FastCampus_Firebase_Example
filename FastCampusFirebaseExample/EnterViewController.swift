//
//  EnterViewController.swift
//  FastCampusFirebaseExample
//
//  Created by Boyoung Park on 21/04/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import FirebaseDatabase

class EnterViewController: UIViewController {
    var ref: DatabaseReference!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
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
