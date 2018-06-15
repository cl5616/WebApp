//
//  ProfileViewController.swift
//  College Posters
//
//  Created by 姜曦 on 30/05/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var introduction: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var nickNameLbl: UILabel!
    var user : User? {
        didSet {
            update()
        }
    }
    static var connectUser : User?
    
    var didChangeNewProfilePic = false
    
    func update() {
        DispatchQueue.main.async {
            self.nickNameLbl.text = self.user?.username
            self.introduction.text = self.user?.intro
            if (self.user?.profileImg != nil) {
                self.profileImage.image = self.user?.profileImg
            }
            self.emailLbl.text = self.user?.userEmail
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("called")
        if (ProfileCredentialViewController.pressButton) {
            self.user = ProfileViewController.connectUser
            ProfileCredentialViewController.pressButton = false
        }
        update()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = LogInViewController.userId.userid
        if user != nil {
            update()
        }
        else {
            HttpApiService.sharedHttpApiService.fetchUserProfile(userID) { (user) in
                self.user = user
            }
        }
    }
    
    static func editProfile(postString: String) {
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
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(data)
                    print(error)
                }
            }
        }.resume()
    }

    @IBAction func pressSave(_ sender: Any) {
        
        var filename = ""
        if (didChangeNewProfilePic) {
            filename = "&image=\(uploadNewProfilePic())"
            didChangeNewProfilePic = false
        }
        var postString = "intro=\(introduction.text ?? "")"
        postString.append(filename)

        ProfileViewController.editProfile(postString: postString)
        let userID = LogInViewController.userId.userid
        HttpApiService.sharedHttpApiService.fetchUserProfile(userID) { (user) in
            self.user = user
            self.update()
        }
    }
    
    func uploadNewProfilePic() -> String {
        
        let data = UIImageJPEGRepresentation(profileImage.image!, 0.5)
        let newImage = UIImage(data: data!)
        
        var selectedPhotos = [newImage]
        
        let url = URL(string: "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/uploadpic.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let session = URLSession.shared
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-type")
        
        var filename_array: [String] = []
        
        for _ in 1...selectedPhotos.count {
            filename_array.append("")
        }
        
        for i in 0...selectedPhotos.count - 1 {
            let photo = selectedPhotos[i]
            guard let mediaImage = PostDetails(withImage: photo!, forType: "image/jpg") else {
                return ""
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
                        //print(json)
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
        return filenames
    }
    
    @IBAction func pressChangePasswordAndName(_ sender: Any) {
        performSegue(withIdentifier: "profileChanger", sender: nil)
    }
    
    @IBAction func uploadImageAction(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            profileImage.image = selectedImage
            didChangeNewProfilePic = true
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
