//
//  BtnActions.swift
//  CollegePosters
//
//  Created by 姜曦 on 14/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import Foundation
import UIKit

class BtnActions: NSObject {
    
    
    
    func handleSwipe(_ sender: UIScreenEdgePanGestureRecognizer, originC: CGPoint, frame: CGRect) {
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: sender.view)
            let changeX = (sender.view?.center.x)! + translation.x
            
            sender.view?.center = CGPoint(x: changeX, y: originC.y)
            sender.setTranslation(.zero, in: sender.view)
        }
        
        if sender.state == .ended {
            if (sender.view?.center.x)! > frame.width {
                UIView.animate(withDuration: 0.3, animations: {
                    sender.view?.center = CGPoint(x: frame.width + frame.width / 2, y: (originC.y))
                }) { (completed) in
                    if completed {
                        sender.view?.removeFromSuperview()
                    }
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    sender.view?.center = originC
                }
            }
            
            sender.setTranslation(.zero, in: sender.view)
        }
        
        if sender.state == .cancelled {
            if (sender.view?.center.x)! > frame.width {
                UIView.animate(withDuration: 0.3, animations: {
                    sender.view?.center = CGPoint(x: frame.width + frame.width / 2, y: (originC.y))
                }) { (completed) in
                    if completed {
                        sender.view?.removeFromSuperview()
                    }
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    sender.view?.center = originC
                }
            }
            sender.setTranslation(.zero, in: sender.view)
        }
        
    }
    
    func likeBtnTapped(sender: UIButton!) -> Void {
        print("like btn tapped")
        
        guard let sender = sender as? likeButton else {
            print("button type casting failed")
            return
        }
        
        if !sender.likeBtnPressed {
            sender.likeBtnPressed = true
            let like = !(sender.poster?.liked)!
            like ? print("is liking") : print("is unliking")
            HttpApiService.sharedHttpApiService.likeBtnPressed(with: sender.posterId!, btn: sender, like: like)
        }
        
    }
    
}
