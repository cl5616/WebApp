//
//  PosterDetailLauncher.swift
//  CollegePosters
//
//  Created by 姜曦 on 11/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import Foundation
import UIKit

class PosterDetailLauncher : NSObject{
    
    var posterDetailView : PostImagesView = {
        if let keyWindow = UIApplication.shared.keyWindow {
            let piv = PostImagesView()
            piv.translatesAutoresizingMaskIntoConstraints = false
            //test
            let img1 = UIImage(named: "heart33")
            let img2 = UIImage(named: "fire64")
            let img3 = UIImage(named: "mag33")
            piv.selectedPhotos = [img1, img2, img3] as? [UIImage]
            
            return piv
        }
        print("failed to intialize posterDetailView")
        return PostImagesView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }()
    
    var exitGesture = UIScreenEdgePanGestureRecognizer()
    
    var mainV: UIView?
    
    func showPosterDetail() {
        
        guard let keyWindow = UIApplication.shared.keyWindow else{
            print("fail to retrieve keyWindow")
            return
        }
        
        let view = UIView(frame: keyWindow.frame)
        mainV = view
        view.backgroundColor = UIColor.orange
        view.frame = CGRect(x: keyWindow.frame.width - 5, y: 0, width: 5, height: keyWindow.frame.height)
            
        view.addSubview(posterDetailView)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": posterDetailView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": posterDetailView]))
        view.addConstraint(NSLayoutConstraint(item: posterDetailView, attribute: .height, relatedBy: .equal, toItem: posterDetailView, attribute: .width, multiplier: 1, constant: 0))
        
            
        keyWindow.addSubview(view)
            
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            view.frame = keyWindow.frame
        }) { (completedAnimation) in
            view.backgroundColor = UIColor.gray
        }
        
        print("x: \(view.frame.minX)")
        print("y: \(view.frame.minY)")
        
        view.addGestureRecognizer(exitGesture)
        
    }
}


