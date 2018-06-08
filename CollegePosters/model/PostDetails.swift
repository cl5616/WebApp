//
//  PostDetails.swift
//  CollegePosters
//
//  Created by Pinchu on 2018/6/7.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

struct PostDetails: Codable {
    let id: String
    let data: Data
    let type: String
    
    init?(withImage image: UIImage, forType type: String) {
        // picture always has type 1
        // id randomly chosen from 1 to int.max
        self.type = type
        self.id = "\(arc4random())"
        
        guard let data = UIImageJPEGRepresentation(image, 1) else {
            return nil
        }
        self.data = data
    }
}
