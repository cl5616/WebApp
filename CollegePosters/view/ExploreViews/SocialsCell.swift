//
//  SocialsCell.swift
//  CollegePosters
//
//  Created by 姜曦 on 06/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class SocialsCell: ExploreBaseCell {

    
    override func fetchPosters(from: Int) {
        if from == 0 {
            if posters.count != 0 {
                posters = [Poster]()
            }
            self.alreadyLoaded = 0
        }
        
        posterGetter.fetchPosters(with: "getSocialPosters", from: from) { (posters) in
            self.posters.append(contentsOf: posters)
            self.alreadyLoaded += posters.count
            DispatchQueue.main.async {
                self.cvt.reloadData()
                self.isLoading = false
            }
        }
    }
}
