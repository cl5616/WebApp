//
//  ImageViewer.swift
//  CollegePosters
//
//  Created by 姜曦 on 12/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import Foundation
import UIKit

class ImageViewer: NSObject {
    
    let exitGesture = UITapGestureRecognizer()
    
    func showImage(_ image: UIImage) {
        guard let keyWindow = UIApplication.shared.keyWindow else {
            print("failed to retrieve keyWindow (iamgeviewer)")
            return
        }
        let frame = keyWindow.frame
        let view = UIImageView()
        view.frame = CGRect(x: frame.width / 2, y: frame.width / 2, width: 5, height: 5)
        view.addGestureRecognizer(exitGesture)
        view.image = image
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .black
        view.isUserInteractionEnabled = true
        keyWindow.addSubview(view)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            view.frame = keyWindow.frame
        }) { (completedAnimation) in
            
        }
    }
    
}
