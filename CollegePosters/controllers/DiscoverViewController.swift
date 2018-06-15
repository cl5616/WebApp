//
//  DiscoverViewController.swift
//  College Posters
//
//  Created by 姜曦 on 30/05/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    @IBOutlet var searchText: UITextField!
    @IBAction func SendSearchRequest(_ sender: Any) {
    }
    
    var fetchedCountry = [Country]()
    
    @IBAction func pressSearch(_ sender: Any) {
        if (searchText.text != "") {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchText.delegate = self
        parseData()
    }
    
    func sendSearchRequest(keyword: String) -> [Poster] {
        
        var posters = [Poster]()
        
        let url = URL(string: "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/searchposts.php")!
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let postDetailStr = "keyword=\(keyword)"
        request.httpBody = postDetailStr.data(using: .utf8)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                print(data)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    print(json)
                    
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
                            
                            posters.append(newPoster)
                        }
                    }
                } catch {
                    print(error)
                }
            }
            if let error = error {
                print(error)
            }
        }.resume()
        return posters
    }
    
    func parseData() {
        
        fetchedCountry = []
        
        let url = "https://www.doc.ic.ac.uk/project/2017/271/g1727111/WebAppsServer/getposts.php"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with:request) { (data, response, error) in
            
            if (error != nil) {
                print("Error")
            }
            else {
                do {
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSArray
                    
                    for eachFetchedCountry in fetchedData {
                        let eachCountry = eachFetchedCountry as! [String : Any]
                        let country = eachCountry["name"] as! String
                        let capital = eachCountry["capital"] as! String
                        
                        self.fetchedCountry.append(Country(country: country, capital: capital))
                    }
                    print(self.fetchedCountry)
                }
                catch {
                    print("Error 2")
                }
            }
        }
        task.resume()
    }
}

class Country {
    var country : String
    var capital : String
    
    init(country : String, capital : String) {
        self.country = country
        self.capital = capital
    }
}

extension DiscoverViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


