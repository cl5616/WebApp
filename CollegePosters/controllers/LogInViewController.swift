//
//  LogInViewController.swift
//  CollegePosters
//
//  Created by 姜曦 on 06/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    
    @IBOutlet weak var logInView: UIView!
    
    var keyboardPresent: Bool = false
    
    @IBAction func tryLogIn(_ sender: Any) {
        
        var authenticated: Bool = false
        //todo parse email -> send to server for authentication
        let email = usernameTxt.text?.lowercased() ?? ""
        let password = passwordTxt.text ?? ""
        let url = URL(string: "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/login.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let loginDetailStr = "email=\(email)&password=\(password)"
        request.httpBody = loginDetailStr.data(using: .utf8)
        let session = URLSession.shared
        var errorMessage = ""
        session.dataTask(with: request) {(data, response, error) in
            /*if let response = response {
                print(response)
            }*/
            if let data = data {
                do {
                    /*if data.count == 0 {
                        //print("login failed...")
                        authenticated = false
                    }*/
                    // store cookies
                    // store user session
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    let status = json["status"] as! Int
                    if status == 1 {
                        authenticated = true
                    } else if status == 0 {
                        let errorMsg = json["error"] as! String
                        //print("Error msg is \(errorMsg)")
                        errorMessage = errorMsg
                    }
                    //print(json)
                } catch {
                    print(data)
                    print(error)
                }
            }
        }.resume()
        
        var sleep = 99999999

        while sleep > 0 {
            sleep -= 1
        }
        
        if  authenticated {
            //print("Authenicated, perform segue to the main storyboard")
            // store cookies
            // store user session
            performSegue(withIdentifier: "logInSegue", sender: nil)
        } else {
            if errorMessage == "login failed" {
                wrongLoginAlert()
            } else if errorMessage == "argument \"password\" cannot be empty" {
                emptyPasswordAlert()
            }
            passwordTxt.text = ""
        }
        
    }
    
    func wrongLoginAlert() {
        let alert = UIAlertController(title: "Wrong Login" , message: "Please check if the email given is registered, or if the password entered is correct.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func emptyPasswordAlert() {
        let alert = UIAlertController(title: "Empty Password" , message: "Please enter the password to log in.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func pressRegister(_ sender: Any) {
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        logInView.layer.cornerRadius = 15
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !keyboardPresent{
            self.logInView.frame.origin.y -= 40
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
            self.logInView.frame.origin.y += 40
    }

}
