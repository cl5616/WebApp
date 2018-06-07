//
//  PostDetailsViewController.swift
//  CollegePosters
//
//  Created by Pinchu on 2018/6/6.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class PostDetailsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{

    @IBOutlet weak var categorySelection: UITextField!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    let categories = ["Clubs", "Socials", "Academy", "Market", "Job"]
    var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.isEnabled = false
        postDescription.delegate = self
        categorySelection.delegate = self
        postDescription.layer.borderColor = UIColor.black.cgColor;
        postDescription.layer.borderWidth = 1.0;
        postDescription.layer.cornerRadius = 0;
        createToolBarDescription()
        
        /*categorySelection.addTarget(self, action: #selector(editingChanged), for: .editingChanged)*/
        /*postDescription.addTarget(self, action: #selector(editingChanged), for: .editingChanged)*/
        
        createCategoryPicker()
        createToolBarCategory()
        /*postDescription.delegate = self
        postDescription.contentVerticalAlignment = UIControlContentVerticalAlignment.top;*/
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = !(postDescription.text?.isEmpty ?? true) && !(categorySelection.text?.isEmpty ?? true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        sendButton.isEnabled = !(postDescription.text?.isEmpty ?? true) && !(categorySelection.text?.isEmpty ?? true)
    }
    
    /*@objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let category = categorySelection.text, !category.isEmpty/*,
            let description = postDescription.text, !description.isEmpty*/
        else {
            self.sendButton.isEnabled = false
            return
        }
        sendButton.isEnabled = true
    }*/
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyBoardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            
            view.frame.origin.y = -keyBoardRect.height/3
        } else {
            view.frame.origin.y = 0
        }
    }
    
    func createCategoryPicker() {
        let categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categorySelection.inputView = categoryPicker
    }
    
    func createToolBarCategory() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(PostDetailsViewController.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        categorySelection.inputAccessoryView = toolBar
    }
    
    func createToolBarDescription() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(PostDetailsViewController.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        postDescription.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /*func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postDescription.resignFirstResponder()
        return true
    }*/
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

    extension PostDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return categories.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return categories[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedCategory = categories[row]
            categorySelection.text = selectedCategory
        }
        
    }
