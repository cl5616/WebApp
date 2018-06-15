//
//  ProfileCredentialViewController.swift
//  CollegePosters
//
//  Created by shhhh on 2018/6/14.
//  Copyright © 2018年 姜曦. All rights reserved.
//

import UIKit

class ProfileCredentialViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var changeNameField: UITextField!
    
    @IBOutlet weak var oldPassword: UITextField!
    
    @IBOutlet weak var newPassword: UITextField!
    
    @IBOutlet weak var newPasswordTwice: UITextField!
    
    @IBOutlet weak var passwordAlert: UILabel!
    static var pressButton = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeNameField.delegate = self
        oldPassword.delegate = self
        newPassword.delegate = self
        newPasswordTwice.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func saveChangeName(_ sender: Any) {
        if (changeNameField.text != "") {
            let postString = "nickname=\(changeNameField.text ?? "")"
            callEditProfile(postString: postString)
        }
    }
    
    @IBAction func changePasswordAction(_ sender: Any) {
        if (oldPassword.text != "" && newPassword.text != "" && newPasswordTwice.text == newPassword.text) {
            let postString = "oldpsw=\(oldPassword.text ?? "")&newpsw=\(newPassword.text ?? "")"

            let url = URL(string: "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/editprofile.php")
            var request = URLRequest(url: url!)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            print(postString)
            request.httpBody = postString.data(using: .utf8)
            let session = URLSession.shared
            session.dataTask(with: request) {(data, response, error) in
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        print(json)
                        DispatchQueue.main.async {
                            let status = json["status"] as! Int
                            if (status == 1) {
                                self.passwordAlert.text = "Successfully reset your password!"
                            }
                            else if (status == 0) {
                                self.passwordAlert.text = "Your old password is incorrect!"
                            }
                        }
                    } catch {
                        print(data)
                        print(error)
                    }
                }
            }.resume()
            ProfileViewController.editProfile(postString: postString)
            let userID = LogInViewController.userId.userid
            HttpApiService.sharedHttpApiService.fetchUserProfile(userID) { (user) in
                ProfileViewController.connectUser = user
                ProfileCredentialViewController.pressButton = true
            }
        }
        else {
            passwordAlert.text = "Mismatching password! Pease try again."
        }
    }
    
    func callEditProfile(postString:String){
        ProfileViewController.editProfile(postString: postString)
        let userID = LogInViewController.userId.userid
        HttpApiService.sharedHttpApiService.fetchUserProfile(userID) { (user) in
            ProfileViewController.connectUser = user
            ProfileCredentialViewController.pressButton = true
        }
    }
    
    
}
