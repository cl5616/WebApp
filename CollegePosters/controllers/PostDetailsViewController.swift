//
//  PostDetailsViewController.swift
//  CollegePosters
//
//  Created by Pinchu on 2018/6/6.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class PostDetailsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var categorySelection: UITextField!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var anonymousButton: UIButton!
    @IBOutlet weak var anonymousTxt: UITextField!
    
    let categories = ["Clubs", "Social", "Academy", "Market", "Job"]
    var selectedCategory: String?
    var selectedPhotos: [UIImage] = []
    var titleText: String = ""
    var anonymousity: String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        anonymousButton.setImage(UIImage(named: "anonymous"), for: .normal)
        sendButton.isEnabled = false
        postDescription.delegate = self
        categorySelection.delegate = self
        postDescription.layer.borderColor = UIColor.black.cgColor;
        postDescription.layer.borderWidth = 1.0;
        postDescription.layer.cornerRadius = 0;
        createToolBarDescription()
        
        createCategoryPicker()
        createToolBarCategory()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @IBAction func anonymousPressed(_ sender: Any) {
        if (anonymousButton.image(for: .normal) == UIImage(named: "anonymous")) {
            anonymousButton.setImage(UIImage(named: "anonymousfilled"), for: .normal)
            anonymousTxt.text = "ANONYMOUS"
            anonymousity = "0"
        } else {
            anonymousButton.setImage(UIImage(named: "anonymous"), for: .normal)
            anonymousTxt.text = "NON-ANONYMOUS"
            anonymousity = "1"
        }
    }
    @IBAction func sendPressed(_ sender: Any) {
        postUploadRequest()
    }
    
    func postUploadRequest() {
        let url = URL(string: "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/uploadpic.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let session = URLSession.shared
        let boundary = generateBoundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-type")
        
        var filename_array: [String] = []

//        var mediaImages: [PostDetails] = []
        
        for _ in 1...selectedPhotos.count {
            filename_array.append("")
        }
        
        for i in 0...selectedPhotos.count - 1 {
            let photo = selectedPhotos[i]
            guard let mediaImage = PostDetails(withImage: photo, forType: "image/jpg") else {
              return
            }
            
            let parameters = ["type": "1", "id": "\(arc4random())"]
            let dataBody = PostDetailsViewController.createDataBody(withParams: parameters, media: [mediaImage], boundary: boundary)
            request.httpBody = dataBody
            
            session.dataTask(with: request) { (data, response, error) in
                /*if let response = response {
                    print(response)
                }*/
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                        let filename = json["filename"] as! String
                        //print(filename)
                        print(json)
                        filename_array[i] = filename
                    } catch {
                        print(data)
                        print(error)
                    }
                }
            }.resume()
        }
        
        for i in 0...selectedPhotos.count - 1 {
            while filename_array[i] == "" {
                //print("picture name not set yet for \(i)")
            }
        }

        
        let filenames = String(filename_array.joined(separator: ";"))
        //print("combined filename ->")
        //print("joined filename: \(filenames)")
        
        let category = categorySelection.text?.lowercased() ?? ""
        let description = self.postDescription.text ?? ""
        let title = self.titleText
        
        let url1 = URL(string: "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/addpost.php")
        var request1 = URLRequest(url: url1!)
        request1.httpMethod = "POST"
        request1.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let postDetailStr = "category=\(category)&content=\(description)&title=\(title)&picture=\(filenames)&anonymous=\(anonymousity)"
        print(postDetailStr)
        request1.httpBody = postDetailStr.data(using: .utf8)
        let session1 = URLSession.shared
        session1.dataTask(with: request1) {(data, response, error) in
            /*if let response = response {
                print(response)
            }*/
            if let data = data {
                do {
                    /*if data.count == 0 {
                        print("wrong data")
                    }*/
                    /*let json = */try JSONSerialization.jsonObject(with: data, options: [])
                    //print(json)
                } catch {
                    print(data)
                    print(error)
                }
            }
        }.resume()
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    static func createDataBody(withParams params: [String : String]?, media: [PostDetails]?, boundary: String) -> Data {
        let separator = "\r\n"
        var body = Data()
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + separator)")
                body.append("Content-Disposition: form-data; name=\"picture\"; filename=\"randomfilename.jpg\"\(separator)")
                body.append("Content-Type: \(photo.type + separator + separator)")
                body.append(photo.data)
                body.append(separator)
            }
        }
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + separator)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(separator + separator)")
                body.append("\(value)" + separator)
            }
        }
        
        body.append("--\(boundary)--\(separator)")
        return body
    }
    
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = !(postDescription.text?.isEmpty ?? true) && !(categorySelection.text?.isEmpty ?? true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        sendButton.isEnabled = !(postDescription.text?.isEmpty ?? true) && !(categorySelection.text?.isEmpty ?? true)
    }
    
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

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
