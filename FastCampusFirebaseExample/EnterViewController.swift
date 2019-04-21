//
//  EnterViewController.swift
//  FastCampusFirebaseExample
//
//  Created by Boyoung Park on 21/04/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth


class EnterViewController: UIViewController {
    var ref: DatabaseReference
    var userID: String?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.ref = Database.database().reference()
        self.userID = Auth.auth().currentUser?.uid
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attribute()
    }
    
    private func attribute() {
        [nameTextField, birthdayTextField, emailTextField]
            .forEach { $0?.delegate = self }
        
        self.nameTextField.becomeFirstResponder()
        
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
            .child(self.userID ?? "unknown")
            .setValue(userInfo) { [weak self] error, data in
                if let `error` = error {
                    self?.presentAlert(error: error)
                } else {
                    self?.updateUserIDLabel(data: data)
                }
            }
    }
    
    public func presentAlert(error: Error) {
        let alertViewController = UIAlertController(
            title: "입력실패",
            message: """
            데이터 저장에 실패했습니다. 네트워크 환경 확인 후 재시도 해주세요.
            참고: \(error)
            """,
            preferredStyle: .alert
        )
        
        let alertAction = UIAlertAction(
            title: "확인",
            style: .default,
            handler: nil
        )
        
        alertViewController.addAction(alertAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    public func updateUserIDLabel(data: DatabaseReference) {
        
    }
}

extension EnterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
