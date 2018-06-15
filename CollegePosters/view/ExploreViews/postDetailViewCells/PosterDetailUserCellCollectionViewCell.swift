//
//  PosterDescriptionUserCellCollectionViewCell.swift
//  CollegePosters
//
//  Created by 姜曦 on 12/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class PosterDetailUserCellCollectionViewCell: PostDetailCell {
    
    
    override var poster: Poster? {
        didSet {
            setUserInformation()
        }
    }
    
    func setUserInformation() {
        if let pi = poster?.user?.profileImg {
            profileImage.image = pi
        }
        
        if let un = poster?.user?.username {
            userLabel.text = un
        }
    }
    
    let profileImage: CellImageView = {
        let imageView = CellImageView()
        imageView.backgroundColor = UIColor.gray
        imageView.image = nil
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let userLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func buildCell() {
        addSubview(profileImage)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0(40)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": profileImage]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0(40)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": profileImage]))
        
        addSubview(userLabel)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-56-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": userLabel]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": userLabel]))
        
        addSubview(separator)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": separator]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(1)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": separator]))
    }
}
