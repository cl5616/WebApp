//
//  Actions.swift
//  CollegePosters
//
//  Created by 姜曦 on 13/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import Foundation
import UIKit

class CommentAction: NSObject {
    
    override init() {
        super.init()
    }
    
    let blackView = UIView()
    let view: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    let textview: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.borderWidth = 2
        tv.layer.borderColor = UIColor(white: 0, alpha: 0.5).cgColor
        tv.layer.cornerRadius = 10
        return tv
    }()
    
    let sendButton: CommentBtn = {
        let sb = CommentBtn(type: .custom)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.setImage(UIImage(named: "sendCmt"), for: .normal)
        return sb
    }()
    
    var lastPressedBtn: UIButton?
    
    func showCommentEditor(_ sender: UIButton!) {
        
        let btn = sender as! CommentBtn
        
        if lastPressedBtn != nil {
            if lastPressedBtn != sender {
                textview.text = ""
            }
        }
        lastPressedBtn = sender
        
        let senderBtn = sender as! CommentBtn
        if btn.isReply! {
            print("cmt button pressed: replying \(btn.commentId!) on \(btn.postId!)")
        } else {
            print("cmt button pressed: commenting on \(btn.postId!)")
        }
        
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            //adding views
            window.addSubview(blackView)
            window.addSubview(view)
            view.frame = CGRect(x: 0, y: -300, width: window.frame.width, height: 300)
            view.addSubview(textview)
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": textview]))
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[v0]-48-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": textview]))
            
            view.addSubview(sendButton)
            sendButton.commentId = senderBtn.commentId
            sendButton.isReply = senderBtn.isReply
            sendButton.postId = senderBtn.postId
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(33)]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": sendButton]))
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(33)]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": sendButton]))
            
            blackView.frame = window.frame
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissBV)))
            sendButton.addTarget(self, action: #selector(sendComment(_:)), for: .touchUpInside)
            
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.view.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: 300)
            }, completion: nil)
        }
    }
    
    @objc func sendComment(_ sender: UIButton!) {
        print("sending comments")
        let btn = sender as! CommentBtn
        
        HttpApiService.sharedHttpApiService.sendComment(postId: btn.postId!, replyId: btn.commentId, content: textview.text)
        
        textview.text = ""
        dismissBV()
    }
    
    @objc func dismissBV() {
        guard let window = UIApplication.shared.keyWindow else {
            print ("failed to get keywindow")
            return
        }
        textview.endEditing(true)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.view.frame = CGRect(x: 0, y: -300, width: window.frame.width, height: 300)
        }, completion: nil)
    }
    
}
