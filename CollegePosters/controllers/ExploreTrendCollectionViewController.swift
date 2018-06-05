//
//  ExploreTrendCollectionViewController.swift
//  College Posters
//
//  Created by 姜曦 on 31/05/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

private let reuseIdentifier = "trendCell"

class ExploreTrendCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posters: [Poster] = [Poster]()
    var postersSrcUrl: String?
    let menuBar: ExploreMenuBar = {
        let mb = ExploreMenuBar()
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(ExploreTrendCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //test images
        let test1Poster = Poster()
        test1Poster.posterImageName = "heart33"
        test1Poster.posterTitle = "Some stupid title"
        let test2Poster = Poster()
        test2Poster.posterImageName = "test2"
        test2Poster.posterTitle = "Some other stupid title"
        
        posters = [test1Poster, test2Poster]
        

        // Do any additional setup after loading the view.
        
        collectionView?.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        setupMenuBar()
    }
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": menuBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": menuBar]))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ExploreTrendCell
    
        // Configure the cell
        // Configure like button
        cell.likebtn.addTarget(self, action: #selector(likeBtnTapped), for: .touchUpInside)
        
        // Render poster on cell
        cell.poster = posters[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = (width - 20) / 3 * 4
        return CGSize(width: width, height: height + 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    @IBAction func likeBtnTapped(sender: UIButton!) -> Void {
        print("like btn tapped")
        let liked = UIImage(named: "heartfilled33")
        let unliked = UIImage(named: "heart33")
        
        if sender.imageView!.image!.isEqual(liked) {
            sender.setImage(unliked , for: .normal)
        } else {
            sender.setImage(liked, for: .normal)
        }
    }

}
