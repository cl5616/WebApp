//
//  PosterDetailsCollectionViewCell.swift
//  CollegePosters
//
//  Created by 姜曦 on 13/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class PosterDetailsCollectionViewCell: PostDetailCell {

    var comment: Comment? {
        didSet {
            timeLbl.text = comment?.commentTime
            cmtBtn.isReply = true
            cmtBtn.commentId = comment?.commentId
            guard let commenterName = comment?.commenterProfile?.username else {
                print("invalid comment found, no commenter")
                return
            }
            if let replyUser = comment?.replyUserProfile?.username{
                cmterLbl.text = "\(commenterName) replies \(replyUser)"
                
            } else {
                cmterLbl.text = String(commenterName)
            }
            
            if let commenterProfileImg = comment?.commenterProfile?.profileImg {
                profileImg.image = commenterProfileImg
            }
            
            contentLbl.text = comment?.content
        }
    }
    
    let profileImg: UIImageView = {
        let fpi = UIImageView()
        fpi.backgroundColor = .gray
        fpi.clipsToBounds = true
        fpi.translatesAutoresizingMaskIntoConstraints = false
        fpi.layer.cornerRadius = 20
        fpi.layer.masksToBounds = true
        return fpi
    }()
    
    let timeLbl: UILabel = {
        let ftl = UILabel()
        ftl.translatesAutoresizingMaskIntoConstraints = false
        return ftl
    }()
    
    let cmtBtn: CommentBtn = {
        let fcmtImage = UIImage(named: "commentbtn")
        let fbtn = CommentBtn(type: .custom)
        fbtn.frame = CGRect(x: 0,y: 0,width: 33,height: 33)
        fbtn.setImage(fcmtImage, for: .normal)
        fbtn.translatesAutoresizingMaskIntoConstraints = false
        fbtn.isReply = true
        return fbtn
    }()
    
    let cmterLbl: UILabel = {
        let frl = UILabel()
        frl.translatesAutoresizingMaskIntoConstraints = false
        return frl
    }()
    
    let contentLbl: UILabel = {
        let fcl = UILabel()
        fcl.translatesAutoresizingMaskIntoConstraints = false
        fcl.numberOfLines = 0
        fcl.font = UIFont.systemFont(ofSize: 15)
        return fcl
    }()
    
    let separator: UIView = {
        let fsp = UIView()
        fsp.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        fsp.translatesAutoresizingMaskIntoConstraints = false
        return fsp
    }()
    
    override func buildCell() {
        //profile image
        addSubview(profileImg)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0(40)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": profileImg]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0(40)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": profileImg]))
        
        //time
        addSubview(timeLbl)
        addConstraint(NSLayoutConstraint(item: timeLbl, attribute: .top, relatedBy: .equal, toItem: profileImg, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: timeLbl, attribute: .leading, relatedBy: .equal, toItem: profileImg, attribute: .trailing, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: timeLbl, attribute: .height, relatedBy: .equal, toItem: profileImg, attribute: .height, multiplier: 0.5, constant: -1))
        
        //cmtbtn
        addSubview(cmtBtn)
        addConstraint(NSLayoutConstraint(item: cmtBtn, attribute: .top, relatedBy: .equal, toItem: contentLbl, attribute: .bottom, multiplier: 1, constant: 5))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(60)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cmtBtn]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(15)]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cmtBtn]))
        
        //commenter
        addSubview(cmterLbl)
        addConstraint(NSLayoutConstraint(item: cmterLbl, attribute: .bottom, relatedBy: .equal, toItem: profileImg, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: cmterLbl, attribute: .leading, relatedBy: .equal, toItem: profileImg, attribute: .trailing, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: cmterLbl, attribute: .height, relatedBy: .equal, toItem: profileImg, attribute: .height, multiplier: 0.5, constant: -1))
        
        //content
        addSubview(contentLbl)
        addConstraint(NSLayoutConstraint(item: contentLbl, attribute: .top, relatedBy: .equal, toItem: profileImg, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: contentLbl, attribute: .leading, relatedBy: .equal, toItem: profileImg, attribute: .trailing, multiplier: 1, constant: 8))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": contentLbl]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": contentLbl]))
        
        //separator
        addSubview(separator)
        addConstraint(NSLayoutConstraint(item: separator, attribute: .top, relatedBy: .equal, toItem: contentLbl, attribute: .bottom, multiplier: 1, constant: 5))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(1)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": separator]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": separator]))
    }
    
    
}

