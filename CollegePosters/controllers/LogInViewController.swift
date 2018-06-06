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
        
        var authenticated: Bool = true
        //todo parse email -> send to server for authentication
        
        
        
        if  authenticated {
            // store cookies
            // store user session
            performSegue(withIdentifier: "logInSegue", sender: nil)
        } else {
            //usernameTxt.text = ""
            passwordTxt.text = ""
        }
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
