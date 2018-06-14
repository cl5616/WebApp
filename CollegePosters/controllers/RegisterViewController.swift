//
//  RegisterViewController.swift
//  CollegePosters
//
//  Created by Pinchu on 2018/6/13.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var confirmCodeTxt: UITextField!
    @IBOutlet weak var sendCodeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendCodeButton.isEnabled = false
        nextButton.isEnabled = false
        // when email address has not been entered, buttons are not enabled.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        emailTxt.delegate = self
        confirmCodeTxt.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? RegisterDetailViewController {
          destVC.emailAdd = emailTxt.text!
        }
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        performSegue(withIdentifier: "registerDetail", sender: nil)
    }
    
    @IBAction func sendCodePressed(_ sender: Any) {
        // todo: send confirmation code to the email,
        // and verify the email address
        
        let email = emailTxt.text
        let emailComponents = email?.split(separator: "@")
        
        if emailComponents?.count == 2 {
            print(emailComponents![1])
            if !emailComponents![1].hasSuffix("ic.ac.uk") && !emailComponents![1].hasSuffix("imperial.ac.uk") {
                wrongEmailDomain()
            }
        } else {
            wrongEmailDomain()
        }
        
    }
    
    func wrongEmailDomain() {
        let alert = UIAlertController(title: "Invalid Email Address" , message: "The Email Address given is not a valid Imperial College Email Address.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        emailTxt.text = ""
        sendCodeButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTxt.resignFirstResponder()
        confirmCodeTxt.resignFirstResponder()
        if emailTxt.text?.isEmpty ?? true || self.emailTxt.text?.isEmpty ?? true {
            sendCodeButton.isEnabled = false
            nextButton.isEnabled = false
            return true
        }
        sendCodeButton.isEnabled = !(self.emailTxt.text?.isEmpty ?? true)
        nextButton.isEnabled = !(self.confirmCodeTxt.text?.isEmpty ?? true) && !(self.emailTxt.text?.isEmpty ?? true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if emailTxt.text?.isEmpty ?? true || self.emailTxt.text?.isEmpty ?? true {
            sendCodeButton.isEnabled = false
            nextButton.isEnabled = false
        }
        
        sendCodeButton.isEnabled = !(self.emailTxt.text?.isEmpty ?? true)
        nextButton.isEnabled = !(self.confirmCodeTxt.text?.isEmpty ?? true) && !(self.emailTxt.text?.isEmpty ?? true)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            
            view.frame.origin.y = -35
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
