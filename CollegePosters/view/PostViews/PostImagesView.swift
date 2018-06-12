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
    let imageViewer: ImageViewer = {
        let iv = ImageViewer()
        iv.exitGesture.addTarget(self, action: #selector(handleTap(_:)))
        return iv
    }()
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        if sender.state != .cancelled && sender.state != .failed{
            let v = sender.view as! UIImageView
            //v.image = nil
            v.removeFromSuperview()
            selectedOne = false
        }
    }
    
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
    
    var selectedOne = false
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (!selectedOne) {
            selectedOne = true
            print("selected: \(indexPath.item)")
            let sp = selectedPhotos![indexPath.item]
            imageViewer.exitGesture.addTarget(self, action: #selector(handleTap(_:)))
            imageViewer.showImage(sp)
        }
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
