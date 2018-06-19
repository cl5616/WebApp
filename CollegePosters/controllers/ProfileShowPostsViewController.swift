//
//  ProfileShowPostsViewController.swift
//  CollegePosters
//
//  Created by shhhh on 2018/6/17.
//  Copyright © 2018年 姜曦. All rights reserved.
//

import UIKit

class ProfileShowPostsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [Poster]()
    
    var originC: CGPoint?
    
    override func viewDidLoad() {
        
        getAllOfMyPosts()
        /*let poster = Poster()
        poster.posterImage = [UIImage(named: "close")] as! [UIImage]
        poster.posterTitle = "gas"
        poster.posterDescription = "#first tag test"
        poster.time = "2018-06-18 15:46:52.562516"
        poster.postId = 9
        poster.posterImageName = "CQAAAAAAAQAAVQC8AAAA.jpg"
        poster.liked = true
        poster.numOfPoster = 1
        poster.userId = LogInViewController.userId.userid
        poster.user = HttpApiService.sharedHttpApiService.createAnonymousUser()
        poster.isSearchResult = false
        poster.checkedLikeStatus = false
        
        posts.append(poster)*/
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAllOfMyPosts()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newL = PosterDetailLauncher()
        newL.exitGesture.edges = .left
        newL.exitGesture.addTarget(self, action: #selector(handleSwipe(_:)))
        newL.showPosterDetail(posts[indexPath.item])
        originC = newL.mainV?.center
    }
    
    @objc func handleSwipe(_ sender: UIScreenEdgePanGestureRecognizer) {
        BtnActions().handleSwipe(sender, originC: originC!, frame: self.view.frame)
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if let indexPaths = collectionView?.indexPathsForVisibleItems {
            for indexPath in indexPaths {
                if let cell = collectionView?.cellForItem(at: indexPath) as? ProfileCollectionViewCell {
                    cell.isEditing = editing
                }
            }
            
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as! ProfileCollectionViewCell
        
        cell.postImage.image = posts[indexPath.row].posterImage.first
        cell.postTitle.text = posts[indexPath.row].posterTitle?.capitalized
        
        cell.delegate = self
        
        return cell
    }
    
    func getAllOfMyPosts() {
        let userId = LogInViewController.userId.userid
        let url = URL(string: "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/getpostsbyuser.php")
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let offset = "0"
        let limit = "10"
        let order = "0"
        let postString = "userid=\(userId)&offset=\(offset)&&limit=\(limit)&order=\(order)"
        request.httpBody = postString.data(using: .utf8)
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    //print(json)
                    
                    DispatchQueue.main.async {
                        if (json as? [String: AnyObject]) == nil {
                            for dict in json as! [[String: AnyObject]] {
                                let newPoster = Poster()
                                
                                //title
                                newPoster.posterTitle = dict["title"] as? String
                                //content
                                newPoster.posterDescription = dict["content"] as? String
                                //image name
                                var ImageName = dict["picture"] as? String
                                ImageName = ImageName == "null" ? "fire64" : ImageName
                                newPoster.posterImageName = ImageName
                                newPoster.postId = dict["msg_id"] as? Int
                                //time
                                let time = dict["post_time"] as? String
                                let subTime = time?.prefix(19)
                                newPoster.time = String(subTime!)
                                //postId
                                newPoster.postId = dict["msg_id"] as? Int
                                //userId
                                newPoster.userId = dict["poster_id"] as? Int
                                
                                self.posts.append(newPoster)
                            }
                        }
                    }
                } catch {
                    print(data)
                    print(error)
                }
            }
        }.resume()
    }
    
    func sendDeletePostUrl(post: Poster) {
        
        //TODO
        let url = URL(string: "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/deletepost.php")
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "postid=\(post.postId ?? 0)"
        request.httpBody = postString.data(using: .utf8)
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            
            if let data = data {
                do {
                    _ = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                } catch {
                    print(data)
                    print(error)
                }
            }
        }.resume()
    }
}

extension ProfileShowPostsViewController: ProfileCollectionViewCellDelegate {
    func delete(cell: ProfileCollectionViewCell) {
        if let indexPath = collectionView?.indexPath(for: cell) {
            sendDeletePostUrl(post: posts[indexPath.section])
            posts.remove(at: indexPath.section)
            collectionView.deleteItems(at: [indexPath])
        }
    }
}
