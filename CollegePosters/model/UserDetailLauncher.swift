//
//  UserDetailLauncher.swift
//  CollegePosters
//
//  Created by 姜曦 on 17/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import Foundation
import UIKit
import ActiveLabel

class UserDetailLauncher: NSObject {
    
    let view: UIView = {
        let v = UIView()
        return v
    }()
    
    let profileImg: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.gray
        imageView.image = nil
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let usernameLbl: UILabel = {
        let l = UILabel()
        l.backgroundColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let bioLbl: UILabel = {
        let label = ActiveLabel()
        label.numberOfLines = 0
        label.enabledTypes = [.hashtag]
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    let emailLbl: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func showUserDetail(user: User) {
        
        guard let keywindow = UIApplication.shared.keyWindow else {
            print("failed to retrieve keywindow")
            return
        }
        
        let frameWidth = keywindow.frame.width
        
        let viewHeight = (user.intro?.height(withConstrainedWidth: CGFloat(Double(frameWidth) - 56)))! + 140
        
        view.backgroundColor = .white
        view.frame = CGRect(x: 28, y: Double(frameWidth) + 28, width: 1, height: 1)
        
        if user.username == "disguised" {
            profileImg.image = UIImage(named: "anonymous")
        } else {
            profileImg.image = user.profileImg
            usernameLbl.text = user.username
            emailLbl.text = user.userEmail
            bioLbl.text = user.intro
        }
        
        keywindow.addSubview(view)
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 28, y: frameWidth - viewHeight / 2, width: frameWidth - 56, height: viewHeight)
            self.view.layer.cornerRadius = 20
            self.view.layer.borderColor = UIColor(white: 0, alpha: 0.5).cgColor
            self.view.layer.borderWidth = 2
        }) { (complete) in
            self.buildView()
        }
        
        
        
    }
    
    func buildView() {
        
        //profile Img
        view.addSubview(profileImg)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0(80)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": profileImg]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0(80)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": profileImg]))
        
        //username
        view.addSubview(usernameLbl)
        view.addConstraint(NSLayoutConstraint(item: usernameLbl, attribute: .leading, relatedBy: .equal, toItem: profileImg, attribute: .trailing, multiplier: 1, constant: 15))
        view.addConstraint(NSLayoutConstraint(item: usernameLbl, attribute: .top, relatedBy: .equal, toItem: profileImg, attribute: .top, multiplier: 1, constant: 0))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(35)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": usernameLbl]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": usernameLbl]))
        
        //email
        view.addSubview(emailLbl)
        view.addConstraint(NSLayoutConstraint(item: emailLbl, attribute: .leading, relatedBy: .equal, toItem: profileImg, attribute: .trailing, multiplier: 1, constant: 15))
        view.addConstraint(NSLayoutConstraint(item: emailLbl, attribute: .bottom, relatedBy: .equal, toItem: profileImg, attribute: .bottom, multiplier: 1, constant: 0))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(35)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": emailLbl]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": emailLbl]))
        
        //bio
        view.addSubview(bioLbl)
        view.addConstraint(NSLayoutConstraint(item: bioLbl, attribute: .leading, relatedBy: .equal, toItem: profileImg, attribute: .leading, multiplier: 1, constant: 20))
        view.addConstraint(NSLayoutConstraint(item: bioLbl, attribute: .top, relatedBy: .equal, toItem: profileImg, attribute: .bottom, multiplier: 1, constant: 30))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": bioLbl]))
        //NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-35-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": bioLbl]))
        
    }
    
    func dismissView() {
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        view.removeFromSuperview()
    }
    
}
