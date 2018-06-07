//
//  CategoryCell.swift
//  CollegePosters
//
//  Created by 姜曦 on 05/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class TrendCell: ExploreBaseCell {
    
    override func testImages() {
        let test1Poster = Poster()
        test1Poster.posterImageName = "heart33"
        test1Poster.posterTitle = "Some stupid title"
        let test2Poster = Poster()
        test2Poster.posterImageName = "test2"
        test2Poster.posterTitle = "Some other stupid title"
        
        posters = [test1Poster, test2Poster]
    }
    
}
