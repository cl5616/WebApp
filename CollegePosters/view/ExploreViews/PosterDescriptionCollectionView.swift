//
//  PosterDescriptionScrollView.swift
//  CollegePosters
//
//  Created by 姜曦 on 12/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class PosterDescriptionCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let idxToIdMap = [0: "user", 1: "content", 2: "comment"]
    let imageViewer = ImageViewer()
    
    
    lazy var cvt: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    var poster: Poster? {
        didSet {
            DispatchQueue.main.async {
                self.cvt.reloadData()
            }
        }
    }
    var comment: [UIView]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cvt.register(PosterDetailUserCellCollectionViewCell.self, forCellWithReuseIdentifier: "user")
        cvt.register(PosterDetailContentCollectionViewCell.self, forCellWithReuseIdentifier: "content")
        cvt.register(PosterDetailCommentCollectionViewCell.self, forCellWithReuseIdentifier: "comment")
        
        addSubview(cvt)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cvt]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cvt]))
        
        cvt.backgroundColor = .white
        backgroundColor = .brown
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let idx = indexPath.item > 2 ? 2 : indexPath.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idxToIdMap[idx]!, for: indexPath)
        
        if idx == 1 {
            let cell = cell as! PosterDetailContentCollectionViewCell
            cell.poster = poster
        }
        
        cell.sizeToFit()
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = frame.width
        
        switch indexPath.item {
        case 0:
            return CGSize(width: width, height: 56)
        case 1:
            return CGSize(width: width, height: 200)
        case 2:
            return CGSize(width: width, height: 100)
        default:
            return CGSize(width: width, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
