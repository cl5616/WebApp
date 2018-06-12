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
        
        return shs
    }()
    
    var urls: [String: String] = [String: String]()
    var posters: [Poster]?
    
    private init() {
        
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
                        newPoster.posterTitle = dict["title"] as? String
                        newPoster.posterDescription = dict["content"] as? String
                        newPoster.time = dict["post_time"] as? String
                        var ImageName = dict["picture"] as? String
                        ImageName = ImageName == "null" ? "fire64" : ImageName
                        newPoster.posterImageName = ImageName
                        newPoster.postId = dict["msg_id"] as? Int
                        let time = dict["post_time"] as? String
                        let subTime = time?.prefix(19)
                        newPoster.time = String(subTime!)
                        self.posters?.append(newPoster)
                    }
                }
                
                
                
                completion(self.posters!)
                
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
        
    }
    
}
