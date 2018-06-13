//
//  PosterDetailContentCollectionViewCell.swift
//  CollegePosters
//
//  Created by 姜曦 on 12/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class PosterDetailContentCollectionViewCell: PostDetailCell {
    
    override var poster: Poster? {
        didSet {
            if let description = poster?.posterDescription {
                contentLabel.text = description
            }
            cmtbtn.isReply = false
            cmtbtn.postId = poster?.postId
        }
    }
    
    var cmtbtn : CommentBtn = {
        let cmtImage = UIImage(named: "comment33")
        let btn = CommentBtn(type: .custom)
        btn.frame = CGRect(x: 0,y: 0,width: 33,height: 33)
        btn.setImage(cmtImage, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isReply = false
        return btn
    }()
    
    let contentLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func buildCell() {
        addSubview(contentLabel)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": contentLabel]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-35-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": contentLabel]))
        
        addSubview(cmtbtn)
        addConstraint(NSLayoutConstraint(item: cmtbtn, attribute: .bottom, relatedBy: .equal, toItem: contentLabel, attribute: .top, multiplier: 1, constant: 2))
        addConstraint(NSLayoutConstraint(item: cmtbtn, attribute: .trailing, relatedBy: .equal, toItem: contentLabel, attribute: .trailing, multiplier: 1, constant: 0))
        
        addSubview(separator)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": separator]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(1)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": separator]))
    }
}

class CommentBtn : UIButton {
    var isReply: Bool?
    var commenter: Int?
    var postId: Int?
}
