//
//  PosterDetailCommentCollectionViewCell.swift
//  CollegePosters
//
//  Created by 姜曦 on 12/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class PosterDetailCommentCollectionViewCell: PostDetailCell {
 
    var comments: [Comment]? {
        didSet {
            idx = 0
            dict = [Int: UILabel]()
            cmbBtns = [CommentBtn]()
            buildCell()
        }
    }
    var idx = 0
    var dict = [Int: UILabel]()
    var cmbBtns = [CommentBtn]()
    
    override func buildCell() {
        guard let comments = comments else {
            print("comments not initialised")
            return
        }
        
        guard  comments.count > 0 else {
            print("initialised with 0 comments")
            return
        }
        
        let first = comments.first
        let fpi = UIImageView()
        fpi.backgroundColor = .gray
        fpi.clipsToBounds = true
        fpi.translatesAutoresizingMaskIntoConstraints = false
        fpi.layer.cornerRadius = 20
        fpi.layer.masksToBounds = true
        //profile image
        addSubview(fpi)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0(40)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": fpi]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0(40)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": fpi]))
        //time
        let ftl = UILabel()
        ftl.translatesAutoresizingMaskIntoConstraints = false
        ftl.text = first?.commentTime
        addSubview(ftl)
        addConstraint(NSLayoutConstraint(item: ftl, attribute: .top, relatedBy: .equal, toItem: fpi, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: ftl, attribute: .leading, relatedBy: .equal, toItem: fpi, attribute: .trailing, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: ftl, attribute: .height, relatedBy: .equal, toItem: fpi, attribute: .height, multiplier: 0.5, constant: -1))
        //cmt btn
        let fcmtImage = UIImage(named: "comment33")
        let fbtn = CommentBtn(type: .custom)
        fbtn.frame = CGRect(x: 0,y: 0,width: 33,height: 33)
        fbtn.setImage(fcmtImage, for: .normal)
        fbtn.translatesAutoresizingMaskIntoConstraints = false
        fbtn.commentId = first?.commentId
        fbtn.isReply = true
        cmbBtns.append(fbtn)
        addSubview(fbtn)
        addConstraint(NSLayoutConstraint(item: fbtn, attribute: .top, relatedBy: .equal, toItem: fpi, attribute: .top, multiplier: 1, constant: 0))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(33)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": fbtn]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(33)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": fbtn]))
        //commenter and optional reply
        let frl = UILabel()
        frl.translatesAutoresizingMaskIntoConstraints = false
        guard let commenterId = first?.commenterId else {
            print("invalid comment found, no commenter")
            return
        }
        if let replyId = first?.replyId{
            frl.text = "\(commenterId) replies \(replyId)"

        } else {
            frl.text = String(commenterId)
        }
        addSubview(frl)
        addConstraint(NSLayoutConstraint(item: frl, attribute: .bottom, relatedBy: .equal, toItem: fpi, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: frl, attribute: .leading, relatedBy: .equal, toItem: fpi, attribute: .trailing, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: frl, attribute: .height, relatedBy: .equal, toItem: fpi, attribute: .height, multiplier: 0.5, constant: -1))
        //comment content
        let fcl = UILabel()
        fcl.translatesAutoresizingMaskIntoConstraints = false
        fcl.text = first?.content
        let fclh = first?.content?.height(withConstrainedWidth: frame.width - 56)
        guard fclh != nil else {
            print("failed to calculate height")
            return
        }
        fcl.numberOfLines = 0
        fcl.font = UIFont.systemFont(ofSize: 15)
        addSubview(fcl)
        addConstraint(NSLayoutConstraint(item: fcl, attribute: .top, relatedBy: .equal, toItem: fpi, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: fcl, attribute: .leading, relatedBy: .equal, toItem: fpi, attribute: .trailing, multiplier: 1, constant: 8))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(fclh!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": fcl]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": fcl]))
        
        dict[idx] = fcl
        idx += 1
        
        for comment in comments.suffix(from: 1) {
            let lastIdx = idx - 1
            let lastLabel = dict[lastIdx]
            //profile image
            let pi = UIImageView()
            pi.backgroundColor = .gray
            pi.clipsToBounds = true
            pi.translatesAutoresizingMaskIntoConstraints = false
            pi.layer.cornerRadius = 20
            pi.layer.masksToBounds = true
            addSubview(pi)
            addConstraint(NSLayoutConstraint(item: pi, attribute: .top, relatedBy: .equal, toItem: lastLabel, attribute: .bottom, multiplier: 1, constant: 18))
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(40)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": pi]))
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0(40)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": pi]))
            //time
            let tl = UILabel()
            tl.translatesAutoresizingMaskIntoConstraints = false
            tl.text = comment.commentTime
            addSubview(tl)
            addConstraint(NSLayoutConstraint(item: tl, attribute: .top, relatedBy: .equal, toItem: pi, attribute: .top, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: tl, attribute: .leading, relatedBy: .equal, toItem: pi, attribute: .trailing, multiplier: 1, constant: 8))
            addConstraint(NSLayoutConstraint(item: tl, attribute: .height, relatedBy: .equal, toItem: pi, attribute: .height, multiplier: 0.5, constant: -1))
            //cmt btn
            let cmtImage = UIImage(named: "comment33")
            let btn = CommentBtn(type: .custom)
            btn.frame = CGRect(x: 0,y: 0,width: 33,height: 33)
            btn.setImage(cmtImage, for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.commentId = comment.commentId
            btn.isReply = true
            cmbBtns.append(btn)
            addSubview(btn)
            addConstraint(NSLayoutConstraint(item: btn, attribute: .top, relatedBy: .equal, toItem: pi, attribute: .top, multiplier: 1, constant: 0))
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(33)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": btn]))
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(33)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": btn]))
            //commenter and optional reply
            let rl = UILabel()
            rl.translatesAutoresizingMaskIntoConstraints = false
            guard let commenterId = comment.commenterId else {
                print("invalid comment found, no commenter")
                return
            }
            if let replyId = comment.replyId{
                rl.text = "\(commenterId) replies \(replyId)"
            } else {
                rl.text = String(commenterId)
            }
            addSubview(rl)
            addConstraint(NSLayoutConstraint(item: rl, attribute: .bottom, relatedBy: .equal, toItem: pi, attribute: .bottom, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: rl, attribute: .leading, relatedBy: .equal, toItem: pi, attribute: .trailing, multiplier: 1, constant: 8))
            addConstraint(NSLayoutConstraint(item: rl, attribute: .height, relatedBy: .equal, toItem: pi, attribute: .height, multiplier: 0.5, constant: -1))
            //comment content
            let cl = UILabel()
            cl.translatesAutoresizingMaskIntoConstraints = false
            cl.text = comment.content
            let clh = comment.content?.height(withConstrainedWidth: frame.width - 56)
            guard clh != nil else {
                print("failed to calculate height")
                return
            }
            cl.numberOfLines = 0
            cl.font = UIFont.systemFont(ofSize: 15)
            addSubview(cl)
            addConstraint(NSLayoutConstraint(item: cl, attribute: .top, relatedBy: .equal, toItem: pi, attribute: .bottom, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: cl, attribute: .leading, relatedBy: .equal, toItem: pi, attribute: .trailing, multiplier: 1, constant: 8))
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(clh!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cl]))
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cl]))
            
            dict[idx] = cl
            idx += 1
        }
    }
}
