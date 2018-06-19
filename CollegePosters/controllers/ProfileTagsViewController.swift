//
//  ProfileTagsViewController.swift
//  CollegePosters
//
//  Created by shhhh on 2018/6/18.
//  Copyright © 2018年 姜曦. All rights reserved.
//

import UIKit

class ProfileTagsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    var tags:[String] = []
    
    override func viewDidLoad() {
        
        getAllMyTags()
        tagsCollectionView.reloadData()
        
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let keywindow = UIApplication.shared.keyWindow else {
            print("failed to retrieve keywindow")
            return
        }
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let startVC: UIViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SignedIn")
        pressedHashTag = "#" + tags[indexPath.item]
        
        (startVC as! UITabBarController).selectedIndex = 1
        
        keywindow.rootViewController = startVC
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAllMyTags()
        tagsCollectionView.reloadData()
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileTagCell", for: indexPath) as! ProfileTagsCollectionViewCell
        
        cell.tagLbl.text = tags[indexPath.row]
        
        cell.delegate = self
        
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if let indexPaths = tagsCollectionView?.indexPathsForVisibleItems {
            for indexPath in indexPaths {
                if let cell = tagsCollectionView?.cellForItem(at: indexPath) as? ProfileTagsCollectionViewCell {
                    cell.isEditing = editing
                }
            }

        }
    }
    
    func sendDeleteTagUrl(tag: String) {
        let url = URL(string: "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/unfollowtag.php")
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "tag=\(tag)"
        request.httpBody = postString.data(using: .utf8)
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            
            if let data = data {
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    HttpApiService.sharedHttpApiService.fetchUserProfile(LogInViewController.userId.userid, completion: { (user) in
                        LogInViewController.userProfile = user
                    })
                } catch {
                    print(data)
                    print(error)
                }
            }
        }.resume()
    }
    
    
    func getAllMyTags() {
        let userId = LogInViewController.userId.userid
        let url = URL(string: "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/getprofile.php")
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "userid=\(userId)"
        request.httpBody = postString.data(using: .utf8)
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    print(json)
                
                    DispatchQueue.main.async {
                        self.tags = json["tags"] as! [String]
                    }
                } catch {
                    print(data)
                    print(error)
                }
            }
        }.resume()
    }
}

extension ProfileTagsViewController : TagCellDelegate
{
    func delete(cell: ProfileTagsCollectionViewCell) {
        if let indexPath = tagsCollectionView?.indexPath(for: cell) {
            sendDeleteTagUrl(tag: tags[indexPath.item])
            print([indexPath])
            tags.remove(at: indexPath.section)
            tagsCollectionView?.deleteItems(at: [indexPath])
        }
    }
}
