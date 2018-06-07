//
//  PostImagesView.swift
//  CollegePosters
//
//  Created by Pinchu on 2018/6/6.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class PostImagesView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
  
    //ar postImagesController: PostViewController?
    var cellID = "adfj"
    var selectedPhotos: [UIImage]?
    lazy var cv: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv2 = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv2.translatesAutoresizingMaskIntoConstraints = false
        cv2.dataSource = self
        cv2.delegate = self
        cv2.backgroundColor = UIColor.lightGray
        return cv2
    }()

    override init(frame: CGRect) {
        print("initialising uiview")
        super.init(frame: frame)
        addSubview(cv)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cv]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cv]))
        
        cv.register(PostImagesViewCell.self, forCellWithReuseIdentifier: cellID)
        
        cv.isPagingEnabled = true
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedPhotos?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PostImagesViewCell
        
        //config cell
        cell.image = selectedPhotos?[indexPath.item]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
        print("required init")
        addSubview(cv)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cv]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cv]))
        
        cv.register(PostImagesViewCell.self, forCellWithReuseIdentifier: cellID)
        
        cv.isPagingEnabled = true
    }
    
}
