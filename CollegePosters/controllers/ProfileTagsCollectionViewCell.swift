//
//  ProfileTagsCollectionViewCell.swift
//  CollegePosters
//
//  Created by shhhh on 2018/6/18.
//  Copyright © 2018年 姜曦. All rights reserved.
//

import UIKit

protocol TagCellDelegate: class {
    func delete(cell: ProfileTagsCollectionViewCell)
}

class ProfileTagsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteButtonBackground: UIVisualEffectView!
    
    @IBOutlet weak var tagLbl: UILabel! {
        didSet {
            deleteButtonBackground.layer.cornerRadius = deleteButtonBackground.bounds.width / 2.0
            deleteButtonBackground.layer.masksToBounds = true
            deleteButtonBackground.isHidden = true
        }
    }
    
    weak var delegate: TagCellDelegate?
    
    var isEditing: Bool = false {
        didSet {
            deleteButtonBackground.isHidden = !isEditing
        }
    }
    
    @IBAction func deleteButtonDidTag(_ sender: Any) {
        delegate?.delete(cell: self)
    }
    
}
