//
//  FilterLauncher.swift
//  CollegePosters
//
//  Created by 姜曦 on 18/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import Foundation
import UIKit

class FilterLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let settings = ["relevance", "time", "popularity"]
    
    
    
    let blackView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return v
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    var height: Int {
        return Int(UIApplication.shared.statusBarFrame.height + 180)
    }
    let cellId = "cellId"
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func showFilterOptions() {
        
        if let window = UIApplication.shared.keyWindow {
            
            //vars
            let frame = window.frame
            
            //adding subviews
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            //config black view
            blackView.frame = window.frame
            blackView.isUserInteractionEnabled = true
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissBV)))
            blackView.alpha = 0
            
            //config collection view
            collectionView.frame = CGRect(x: 0, y: -height, width: Int(frame.width), height: height)
            
            //animation
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: 0, width: Int(frame.width), height: self.height)
            }, completion: nil)
        }
        
    }
    
    @objc func dismissBV() {
        guard let window = UIApplication.shared.keyWindow else {
            print ("failed to get keywindow")
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.collectionView.frame = CGRect(x: 0, y: -self.height, width: Int(window.frame.width), height: self.height)
        }, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        return CGSize(width: collectionView.frame.width, height: statusBarHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        
        cell.settingName = settings[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SearchCollectionViewController.searchMode = settings[indexPath.item]
        dismissBV()
    }
    
}

