//
//  TagsLauncher.swift
//  CollegePosters
//
//  Created by 姜曦 on 17/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import Foundation
import UIKit


class TagsLauncher: NSObject {
    
    let cellID = "tagPosters"
    
    var searchResult: [Poster] = [Poster]()
    var alreadyLoadedSearchResult = 0
    var isSearching: Bool = false
    var tag: String?
    
    let exitGesture = UIScreenEdgePanGestureRecognizer()
    var mainV: UIView?
    
    let view: UIView = {
        let v = TagsCollectionView()
        v.backgroundColor = .white
        return v
    }()
    
    func showPostersWithTags(tag: String) {
        
        guard let keywindow = UIApplication.shared.keyWindow else {
            print("failed to retrieve keywindow")
            return
        }
        
        self.tag = tag
        
        let width = keywindow.frame.width
        let height = keywindow.frame.height
        let frame = keywindow.frame
        
        mainV = view
        view.frame = CGRect(x: width - 5, y: 0, width: 5, height: height)
        
        keywindow.addSubview(view)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = frame
        }) { (completed) in
            
        }
        
        view.addGestureRecognizer(exitGesture)
    }
}
