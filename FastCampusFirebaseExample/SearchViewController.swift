//
//  SearchViewController.swift
//  FastCampusFirebaseExample
//
//  Created by Boyoung Park on 21/04/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAnalytics

class SearchViewController: UIViewController {
    var ref: DatabaseReference!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var deleteStatusLabel: UILabel!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        self.attribute()
    }
    
    private func attribute() {
        nameTextField.delegate = self
        
        self.nameTextField.becomeFirstResponder()
        self.deleteStatusLabel.isHidden = true
        self.searchButton.isEnabled = false
        self.deleteButton.isEnabled = false
        self.deleteButton.tintColor = .red
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        self.searchUser()
        Analytics.logEvent("검색하기_버튼_클릭", parameters: nil)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        self.deleteUser()
        Analytics.logEvent("삭제하기_버튼_클릭", parameters: nil)
    }
    
    public func searchUser() {
        let userName = self.nameTextField.text
        ref.child("users")
            .queryOrdered(byChild: "name")
            .queryEqual(toValue: userName)
            .queryLimited(toFirst: 1)
            .observeSingleEvent(of: .value) { snapshot in
                guard let userDatas = snapshot.value as? [String: [String: Any]],
                    let userData = userDatas.first else {
                    return presentAlert(base: self, type: .invalidUser)
                }
                
                let userID = userData.key
                let value = userData.value
                
                let birthday = value["birthday"]
                let email = value["email"]
                
                self.userIDLabel.text = userID
                self.birthdayLabel.text = birthday as? String ?? ""
                self.emailLabel.text = email as? String ?? ""
            }
    }
    
    public func deleteUser() {
        let userID = userIDLabel.text ?? ""
        ref.child("users").child(userID).setValue(nil) { error, _ in
            if let `error` = error {
                presentAlert(base: self, type: AlertType.deleteFailed(error: error))
            } else {
                self.deleteStatusLabel.isHidden = false
            }
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let nameTextFilled = self.nameTextField.text != ""
        self.searchButton.isEnabled = nameTextFilled
        self.deleteButton.isEnabled = nameTextFilled
    }
}
