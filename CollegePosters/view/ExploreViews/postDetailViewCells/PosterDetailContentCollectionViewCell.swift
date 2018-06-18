//
//  PosterDetailContentCollectionViewCell.swift
//  CollegePosters
//
//  Created by 姜曦 on 12/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit
import ActiveLabel

var pressedHashTag: String?

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
        let cmtImage = UIImage(named: "commentbtn")
        let btn = CommentBtn(type: .custom)
        btn.frame = CGRect(x: 0,y: 0,width: 33,height: 33)
        btn.setImage(cmtImage, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isReply = false
        return btn
    }()
    
    /*let contentLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()*/
    
    let contentLabel : ActiveLabel = {
        let label = ActiveLabel()
        label.numberOfLines = 0
        label.enabledTypes = [.hashtag]
        label.backgroundColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        // handle the segue when clicking on the hashtag here
        label.handleHashtagTap { hashtag in
            print("Success. You just tapped the \(hashtag) hashtag")
            
            guard let keywindow = UIApplication.shared.keyWindow else {
                print("failed to retrieve keywindow")
                return
            }
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let startVC: UIViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SignedIn")
            pressedHashTag = "#" + hashtag
            
            (startVC as! UITabBarController).selectedIndex = 1
            
            keywindow.rootViewController = startVC
 
            //TagsLauncher().showPostersWithTags(tag: hashtag)
        }
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
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-25-[v0]-25-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": contentLabel]))
        
        addSubview(cmtbtn)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(60)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cmtbtn]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(15)]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cmtbtn]))
        
        addSubview(separator)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": separator]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(1)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": separator]))
    }
}

class CommentBtn : UIButton {
    var isReply: Bool?
    var commentId: Int?
    var postId: Int?
}
