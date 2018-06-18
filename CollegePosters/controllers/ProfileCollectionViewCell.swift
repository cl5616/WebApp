//
//  ProfileCollectionViewCell.swift
//  CollegePosters
//
//  Created by shhhh on 2018/6/17.
//  Copyright © 2018年 姜曦. All rights reserved.
//

import UIKit

protocol ProfileCollectionViewCellDelegate: class {
    func delete(cell: ProfileCollectionViewCell)
}

class ProfileCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: ProfileCollectionViewCellDelegate?
    
    @IBOutlet weak var deleteButtonBackgroundView: UIVisualEffectView!
    @IBOutlet weak var postImage: UIImageView! {
        didSet {
            deleteButtonBackgroundView.layer.cornerRadius = deleteButtonBackgroundView.bounds.width / 2.0
            deleteButtonBackgroundView.layer.masksToBounds = true
            deleteButtonBackgroundView.isHidden = true
        }
    }
    @IBOutlet weak var postTitle: UILabel!
    
    var isEditing: Bool = false {
        didSet {
            deleteButtonBackgroundView.isHidden = !isEditing
        }
    }
    
    @IBAction func deleteButtonDidTap(_ sender: Any) {
        delegate?.delete(cell: self)
    }
}
