//
//  ProfileViewController.swift
//  College Posters
//
//  Created by 姜曦 on 30/05/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var introduction: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var nickNameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = "3"
        display(id: userID)
        
        
    }
    func display(id: String){
        let url = URL(string:"https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/getprofile.php")!
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let postDetailStr = "userid=\(id)"
        request.httpBody = postDetailStr.data(using: .utf8)
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    print(json)
                    self.nickNameLbl.text = json["nickname"] as? String
                    self.emailLbl.text = json["email"] as? String
                    if (json["image"] as! String != "") {
                        self.profileImage.image = UIImage(named:json["image"] as! String)
                    }
                    self.introduction.text = json["introduction"] as? String
                } catch {
                    print(data)
                    print(error)
                }
            }
        }.resume()
    }
    
    @IBAction func pressSave(_ sender: Any) {
    }
    
    @IBAction func pressLogOut(_ sender: Any) {
    }
    
    @IBAction func uploadImageAction(_ sender: Any) {
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
