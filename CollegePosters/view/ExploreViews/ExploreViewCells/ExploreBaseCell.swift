//
//  ExploreBaseCell.swift
//  CollegePosters
//
//  Created by 姜曦 on 05/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class ExploreBaseCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellId"
    var posters: [Poster] = [Poster]()
    let posterGetter = HttpApiService.sharedHttpApiService
    var alreadyLoaded: Int = 0
    var isLoading = false
    var section: String?
    let posterDetail = PosterDetailLauncher()
    var originC: CGPoint?
    var rc = UIRefreshControl()
    
    lazy var cvt: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.brown
        addSubview(cvt)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cvt]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cvt]))
        
        cvt.register(ExploreCell.self, forCellWithReuseIdentifier: cellId)
        cvt.backgroundColor = UIColor.white
        cvt.refreshControl = rc
        rc.tintColor = .black
        rc.addTarget(self, action: #selector(refreshAllPost), for: .valueChanged)
        
        //test images
        setSection()
        fetchPosters(from: 0)
    }
    
    @objc func refreshAllPost() {
        if !isLoading{
            isLoading = true
            fetchPosters(from: 0)
        }
    }
    
    func setSection() {
        return
    }
    
    func fetchPosters(from: Int) {
        if from == 0 {
            if posters.count != 0 {
                posters = [Poster]()
            }
            self.alreadyLoaded = 0
        }
        
        posterGetter.fetchPosters(with: section!, from: from) { (posters) in
            self.posters.append(contentsOf: posters)
            self.alreadyLoaded += posters.count
            DispatchQueue.main.async {
                self.isLoading = false
                self.cvt.reloadData()
                self.rc.endRefreshing()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == alreadyLoaded - 1 && !isLoading{
            isLoading = true
            fetchPosters(from: alreadyLoaded)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ExploreCell
        
        // Configure the cell
        if !isLoading {
            // Configure like button
            cell.likebtn.addTarget(self, action: #selector(likeBtnTapped), for: .touchUpInside)
        
            cell.posterImage.image = nil

            cell.likebtn.imageView?.image = UIImage(named: "heart33")
            
            // Render poster on cell
            cell.poster = posters[indexPath.item]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newL = PosterDetailLauncher()
        newL.exitGesture.edges = .left
        newL.exitGesture.addTarget(self, action: #selector(handleSwipe(_:)))
        newL.showPosterDetail(posters[indexPath.item])
        originC = newL.mainV?.center
    }
    
    @objc func handleSwipe(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: sender.view)
            let changeX = (sender.view?.center.x)! + translation.x
            
            sender.view?.center = CGPoint(x: changeX, y: originC!.y)
            sender.setTranslation(.zero, in: sender.view)
        }
        
        if sender.state == .ended {
            if (sender.view?.center.x)! > frame.width {
                UIView.animate(withDuration: 0.3, animations: {
                    sender.view?.center = CGPoint(x: self.frame.width + self.frame.width / 2, y: (self.originC?.y)!)
                }) { (completed) in
                    if completed {
                        sender.view?.removeFromSuperview()
                    }
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    sender.view?.center = self.originC!
                }
            }
            
            sender.setTranslation(.zero, in: sender.view)
        }
        
        if sender.state == .cancelled {
            if (sender.view?.center.x)! > frame.width {
                UIView.animate(withDuration: 0.3, animations: {
                    sender.view?.center = CGPoint(x: self.frame.width + self.frame.width / 2, y: (self.originC?.y)!)
                }) { (completed) in
                    if completed {
                        sender.view?.removeFromSuperview()
                    }
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    sender.view?.center = self.originC!
                }
            }
            sender.setTranslation(.zero, in: sender.view)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.width
        let height = (width - 20) / 3 * 4
        return CGSize(width: width, height: height + 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @IBAction func likeBtnTapped(sender: UIButton!) -> Void {
        print("like btn tapped")
        let unliked = UIImage(named: "heart33")
        
        
        guard let sender = sender as? likeButton else {
            print("button type casting failed")
            return
        }
        
        if !sender.likeBtnPressed {
            sender.likeBtnPressed = true
            let like = sender.imageView!.image!.isEqual(unliked)
            like ? print("is liking") : print("is unliking")
            HttpApiService.sharedHttpApiService.likeBtnPressed(with: sender.posterId!, btn: sender, like: like)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func testImages() {
        
    }
}
