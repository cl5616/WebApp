//
//  HttpApiService.swift
//  CollegePosters
//
//  Created by 姜曦 on 06/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import Foundation
import UIKit

class HttpApiService {
    
    static let sharedHttpApiService: HttpApiService = {
        let shs = HttpApiService()
        
        //add new URLs to dictionary
        
        return shs
    }()
    
    var urls: [String: String] = [String: String]()
    var posters: [Poster]?
    
    private init() {
        
    }
    
    func fetchPosters(with: String, from: UICollectionViewScrollPosition, completion: ([Poster]) -> ()) {
        
        let url = URL(string: urls[with]!)
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
                
                for dict in json as! [[String: AnyObject]] {
                    let newPoster = Poster()
                    newPoster.posterTitle = dict["posterTitle"] as? String
                    self.posters?.append(newPoster)
                }
                
                if from == .top {
                    
                }
                
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
        
    }
    
}
