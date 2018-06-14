//
//  RegisterDetailViewController.swift
//  CollegePosters
//
//  Created by Pinchu on 2018/6/13.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class RegisterDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatPasswordTxt: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    var emailAdd: String = ""
    
    @IBAction func goPressed(_ sender: Any) {
        if passwordTxt.text != repeatPasswordTxt.text {
            diffPasswordsEnteredAlert()
        }
        registerNewAccount()
    }
    
    func registerNewAccount() {
        let url = URL(string: "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/register.php")
        var request = URLRequest(url: url!)
        let email = emailAdd.lowercased() 
        let password = passwordTxt.text ?? ""
        let nickname = usernameTxt.text ?? ""
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let registerDetailStr = "email=\(email)&password=\(password)&nickname=\(nickname)"
        request.httpBody = registerDetailStr.data(using: .utf8)
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            /*if let response = response {
                print(response)
            }*/
            if let data = data {
                do {
                    /*if data.count == 0 {
                        print("register failed...")
                    }*/
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]

                    //print(json)
                    
                    let status = json["status"] as! Int
                    //print("Status code is \(status)")
                    if status == 1 {
                        self.performSegue(withIdentifier: "registerSuccess", sender: nil)
                    } else if status == 0 {
                        let errorMsg = json["error"] as! String
                        //print("Error msg is \(errorMsg)")
                        if errorMsg == "email has already been registered" {
                            self.emailAlreadyRegisteredAlert()
                            //self.performSegue(withIdentifier: "registerSuccess", sender: nil)
                        }
                    }
                } catch {
                    print(data)
                    print(error)
                }
            }
        }.resume()
    }
    
    func emailAlreadyRegisteredAlert() {
        let alert = UIAlertController(title: "Email already registered" , message: "The Email Address given has already been registered.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        self.performSegue(withIdentifier: "registerSuccess", sender: nil)
    }
    
    func diffPasswordsEnteredAlert() {
        let alert = UIAlertController(title: "Different passwords" , message: "The two passwords entered are not the same", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        passwordTxt.text = ""
        repeatPasswordTxt.text = ""
        goButton.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goButton.isEnabled = false

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        usernameTxt.delegate = self
        passwordTxt.delegate = self
        repeatPasswordTxt.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        repeatPasswordTxt.resignFirstResponder()
        
        if self.usernameTxt.text?.isEmpty ?? true || self.passwordTxt.text?.isEmpty ?? true ||
            self.repeatPasswordTxt.text?.isEmpty ?? true {
            goButton.isEnabled = false
        } else {
            goButton.isEnabled = true
        }
        /*goButton.isEnabled = !(self.usernameTxt.text?.isEmpty ?? true) && !(self.passwordTxt.text?.isEmpty ?? true) && !(self.repeatPasswordTxt.text?.isEmpty ?? true)*/
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.usernameTxt.text?.isEmpty ?? true || self.passwordTxt.text?.isEmpty ?? true ||
            self.repeatPasswordTxt.text?.isEmpty ?? true {
            goButton.isEnabled = false
        } else {
            goButton.isEnabled = true
        }
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            
            view.frame.origin.y = -30
        } else {
            view.frame.origin.y = 0
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
}
