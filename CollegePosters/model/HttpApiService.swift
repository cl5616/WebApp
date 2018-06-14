//
//  HttpApiService.swift
//  CollegePosters
//
//  Created by 姜曦 on 06/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

class HttpApiService {
    
    static let sharedHttpApiService: HttpApiService = {
        let shs = HttpApiService()
        
        //add new URLs to dictionary
        shs.urls["getSocialPosters"] = "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/getposts.php?category=social"
        shs.urls["getTrendPosters"] = "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/getposts.php?sort=1"
        shs.urls["getFollowPosters"] = "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/getposts.php?category=follow"
        shs.urls["getClubsPosters"] = "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/getposts.php?category=clubs"
        shs.urls["getMarketPosters"] = "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/getposts.php?category=market"
        shs.urls["getJobPosters"] = "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/getposts.php?category=job"
        shs.urls["getAcademyPosters"] = "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/getposts.php?category=academy"
        shs.urls["like"] = "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/like.php?"
        shs.urls["unlike"] = "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/unlike.php"
        shs.urls["comment"] = "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/addcomment.php"
        shs.urls["getComments"] = "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/getcomments.php?"
        
        return shs
    }()
    
    var urls: [String: String] = [String: String]()
    var posters: [Poster]?
    
    private init() {
        
    }
    
    func fetchComment(postId: Int, from: Int, completion: @escaping ([Comment]) -> ()) {
        let rawUrl = urls["getComments"]!
        let combinedUrl = rawUrl + "offset=\(from)&limit=5&msg_id=\(postId)"
        
        let url = URL(string: combinedUrl)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            var comments = [Comment]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                if let json = json as? [[String: AnyObject]] {
                    for dict in json {
                        let newComment = Comment()
                        //commenterId
                        newComment.commenterId = dict["poster_id"] as? Int
                        //commentId
                        newComment.commentId = dict["id"] as? Int
                        //commentTime
                        let time = dict["comment_time"] as? String
                        let subTime = time?.prefix(19)
                        newComment.commentTime = String(subTime!)
                        //content
                        newComment.content = dict["content"] as? String
                        //replyId
                        let ri = dict["reply_id"] as? String
                        if let ri = ri {
                            newComment.replyId = Int(ri)
                        }
                        comments.append(newComment)
                    }
                }
            } catch let jsonErr {
                print(jsonErr)
            }
            completion(comments)
        }.resume()
    }
    
    func sendComment(postId: Int, replyId: Int?, content: String) {
        let url = URL(string: urls["comment"]!)
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        var postString = "msg_id=\(postId)&content=\(content)"
        if let replyId = replyId {
            postString += "&reply_id=\(replyId)"
        }
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                print(response!)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                print("comment status: \(json["status"] as! Int)")
                
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func likeBtnPressed(with: Int, btn: likeButton, like: Bool) {
        let liked = UIImage(named: "heartfilled33")
        let unliked = UIImage(named: "heart33")
        
        let btnId = btn.posterId!
        
        let action = like ? "like" : "unlike"
        let url = URL(string: urls[action]!)
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "post_id=\(with)"
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                btn.likeBtnPressed = false
                print(error!)
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 else {
                btn.likeBtnPressed = false
                print("like failed")
                print("response: \(response!)")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                print("status:  \((json["status"] as! Int))")
                
                if json["status"] as! Int == 1 {
                    DispatchQueue.main.async {
                        if like {
                            btn.poster?.liked = true
                        } else {
                            btn.poster?.liked = false
                        }
                        if (btnId == btn.posterId!) {
                            like ? btn.setImage(liked, for: .normal) : btn.setImage(unliked , for: .normal)
                            btn.likeBtnPressed = false
                        }
                    }
                }
                
            } catch let jsonErr {
                print(jsonErr)
            }
        }.resume()
    }
    
    func fetchPosters(with: String, from: Int, completion: @escaping ([Poster]) -> ()) {
        
        let rawUrl = urls[with]!
        let combinedUrl = rawUrl + "&limit=5&offset=\(from)"
        
        let url = URL(string: combinedUrl)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            /*
            let httpResp: HTTPURLResponse = response as! HTTPURLResponse
            let httpCookies: [HTTPCookie] = HTTPCookie.cookies(withResponseHeaderFields: httpResp.allHeaderFields as! [String: String], for: httpResp.url!)
            HTTPCookieStorage.shared.setCookies(httpCookies, for: response?.url!, mainDocumentURL: nil)
            */
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                self.posters = [Poster]()
                
                if (json as? [String: AnyObject]) == nil {
                    for dict in json as! [[String: AnyObject]] {
                        let newPoster = Poster()
                        
                        //title
                        newPoster.posterTitle = dict["title"] as? String
                        //content
                        newPoster.posterDescription = dict["content"] as? String
                        //image name
                        var ImageName = dict["picture"] as? String
                        ImageName = ImageName == "" ? "fire64" : ImageName
                        newPoster.posterImageName = ImageName
                        //set images 
                        self.setImages(withName: ImageName!, poster: newPoster)
                        //image counts
                        newPoster.numOfPoster = ImageName?.split(separator: ";").count
                        //time
                        let time = dict["post_time"] as? String
                        let subTime = time?.prefix(19)
                        newPoster.time = String(subTime!)
                        //postId
                        newPoster.postId = dict["msg_id"] as? Int
                        //userId
                        newPoster.userId = dict["poster_id"] as? Int
                        
                        self.posters?.append(newPoster)
                    }
                }
                
                
                
                completion(self.posters!)
                
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
        
    }
    
    func searchPoster(with: String, completion: @escaping ([Poster]) -> ()) {
        let url = URL(string: "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/searchposts.php")!
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let postDetailStr = "keyword=\(with)"
        request.httpBody = postDetailStr.data(using: .utf8)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                print(data)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    self.posters = [Poster]()
                    
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
                            
                            self.posters?.append(newPoster)
                        }
                    }
                    completion(self.posters!)
                    
                } catch let jsonError {
                    print(jsonError)
                }
            }
        }.resume()
    }
    func setImages(withName: String, poster: Poster) {
        let picFolderUrl = "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/pic/"
        var combinedUrls = [URL]()
        let subNames = withName.split(separator: ";")
        for picName in subNames {
            let newName = String(picName)
            let newCombinedUrl = picFolderUrl + newName
            combinedUrls.append(URL(string: newCombinedUrl)!)
        }
        
        for idx in 0...combinedUrls.count - 1 {
            URLSession.shared.dataTask(with: combinedUrls[idx]) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                let imageToCache = UIImage(data: data!)
                if let imageToCache = imageToCache {
                    imageCache.setObject(imageToCache, forKey: String(subNames[idx]) as NSString)
                    poster.posterImage.append(imageToCache)
                }
            }.resume()
        }
    }
    
}
