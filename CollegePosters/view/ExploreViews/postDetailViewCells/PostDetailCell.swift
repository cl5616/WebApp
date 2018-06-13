//
//  PostDetailCell.swift
//  CollegePosters
//
//  Created by 姜曦 on 12/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class PostDetailCell: UICollectionViewCell {
    
    var poster: Poster?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        buildCell()
    }
    
    func buildCell() {
        return
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
