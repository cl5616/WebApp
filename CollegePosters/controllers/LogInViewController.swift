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
    var errorMessage = ""
    var authenticated: Bool = false {
        didSet {
            if authenticated {
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                let data: Data = NSKeyedArchiver.archivedData(withRootObject: cookies.httpCookies)
                UserDefaults.standard.set(data, forKey: "cookies")
                UserDefaults.standard.set(cookies.url, forKey: "cookiesURL")
                UserDefaults.standard.set(userId.userid, forKey: "userid")
                print("Setting userid to \(userId.userid)")
                //UserDefaults.standard.
//                print(UserDefaults.standard.integer(forKey: "userid"))
//                print(UserDefaults.standard.url(forKey: "cookiesURL"))
  //              UserDefaults.standard.synchronize()
                UserDefaults.standard.synchronize()
                DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: "logInSegue", sender: nil)
                })
            } else {
                if errorMessage == "login failed" {
                    //print("login failed")
                    DispatchQueue.main.async(execute: {
                        self.wrongLoginAlert()
                        self.passwordTxt.text = ""
                    })
                } else if errorMessage == "argument \"password\" cannot be empty" {
                    DispatchQueue.main.async(execute: {
                        self.emptyPasswordAlert()
                        self.passwordTxt.text = ""
                        //print("password cannot be empty")
                    })
                }
            }
        }
    }

    @IBAction func tryLogIn(_ sender: Any) {

        //var authenticated: Bool = false
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
        //var errorMessage = ""
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
                    let httpResp: HTTPURLResponse = response as! HTTPURLResponse
                    let httpCookies: [HTTPCookie] = HTTPCookie.cookies(withResponseHeaderFields: httpResp.allHeaderFields as! [String: String], for: httpResp.url!)
                    HTTPCookieStorage.shared.setCookies(httpCookies, for: response?.url!, mainDocumentURL: nil)
                    
                    cookies.httpCookies = httpCookies
                    cookies.url = (response?.url!)!
                    //print ("header: \(httpResp.allHeaderFields as! [String: String])")
                    // store user session
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    let status = json["status"] as! Int
                    if status == 1 {
                        let uid = json["id"] as! Int
                        userId.userid = uid
                        self.authenticated = true
                    } else if status == 0 {
                        self.authenticated = false
                        let errorMsg = json["error"] as! String
                        self.errorMessage = errorMsg
                    }
                    //print(json)
                } catch {
                    print(data)
                    print(error)
                }
            }
        }.resume()
    }
    
    struct userId {
        static var userid = Int()
    }
    
    struct cookies {
        static var httpCookies = [HTTPCookie]()
        static var url: URL?
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

        logInView.layer.cornerRadius = 15
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if !keyboardPresent{
            //self.logInView.frame.origin.y = -5
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
            self.logInView.frame.origin.y = 0
    }

}
