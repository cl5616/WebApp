//
//  followCell.swift
//  CollegePosters
//
//  Created by 姜曦 on 05/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class FollowCell: ExploreBaseCell {
    
    override func testImages() {
        let test2Poster = Poster()
        test2Poster.posterImageName = "fire64"
        test2Poster.posterTitle = "Some stupid title"
        let test1Poster = Poster()
        test1Poster.posterImageName = "fire64"
        test1Poster.posterTitle = "Some other stupid title"
        
        posters = [test1Poster, test2Poster]
    }
    
    override func setSection() {
        self.section = "getFollowPosters"
    }
    
    override func fetchPosters(from: Int) {
        if from == 0 {
            if posters.count != 0 {
                posters = [Poster]()
                postersId = [Int]()
            }
            self.alreadyLoaded = 0
        }
        
        posterGetter.fetchPosters(with: section!, from: from, keyword: nil, tags: tagsToString(LogInViewController.userProfile!)) { (posters) in
            //self.posters.append(contentsOf: posters)
            self.selectForRender(posters: posters)
            self.alreadyLoaded += posters.count
            DispatchQueue.main.async {
                self.isLoading = false
                self.cvt.reloadData()
                self.rc.endRefreshing()
            }
        }
    }
    
    func tagsToString(_ user: User) -> String {
        var ret = ""
        
        user.followedTags?.forEach({ (string) in
            ret.append(string + "+")
        })
        
        return ret
    }
    
}
