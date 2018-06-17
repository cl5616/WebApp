//
//  SearchCollectionViewController.swift
//  CollegePosters
//
//  Created by 姜曦 on 14/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SearchCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    let searchBarHeight = 40
    
    var searchResult: [Poster] = [Poster]()
    var alreadyLoadedSearchResult = 0
    var isSearching: Bool = false
    lazy var tap: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer()
        t.addTarget(self, action: #selector(dismissKeyboardFromSearch))
        //t.delegate = self
        return t
    }()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.delegate = self
        sb.placeholder = "poster keyword"
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(ExploreCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        self.collectionView?.isUserInteractionEnabled = true
        view.addSubview(searchBar)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(searchBarHeight))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": searchBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": searchBar]))
        searchBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        
        
    }
    
    lazy var tempView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.borderWidth = 2
        v.layer.borderColor = UIColor(white: 0, alpha: 0.5).cgColor
        v.layer.cornerRadius = 20
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedTempView)))
        v.isUserInteractionEnabled = true
        
        return v
    }()
    
    @objc func tappedTempView() {
        print("trying to follow")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let hashtag = pressedHashTag {
            searchBar.text = hashtag
            self.searchBarSearchButtonClicked(searchBar)
            pressedHashTag = nil
        }
    }
    
    func searchForPosters(keyword: String, from: Int) {
        
        if !isSearching {
            isSearching = true
            if from == 0{
                searchResult = [Poster]()
                alreadyLoadedSearchResult = 0
            }
            
            HttpApiService.sharedHttpApiService.fetchPosters(with: "getTrendPosters", from: alreadyLoadedSearchResult, keyword: keyword) { (posters) in
                self.sortNAppend(posters: posters)
                self.alreadyLoadedSearchResult += posters.count
                DispatchQueue.main.async {
                    self.isSearching = false
                    self.collectionView!.reloadData()
                }
            }
        }
    }
    
    func sortNAppend(posters: [Poster]) {
        if let op = originalPoster {
            for poster in posters {
                if op.postId == poster.postId {
                    searchResult.insert(poster, at: 0)
                    continue
                }
                searchResult.append(poster)
            }
            return
        }
        
        searchResult.append(contentsOf: posters)
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        view.addGestureRecognizer(tap)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            dismissKeyboardFromSearch()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searching " + searchBar.text!)
        if searchBar.text?.first == "#" {
            collectionView?.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
            view.addSubview(tempView)
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(searchBarHeight + 3)-[v0(60)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": tempView]))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": tempView]))
        } else {
            collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            tempView.removeFromSuperview()
        }
        searchForPosters(keyword: searchBar.text!, from: 0)
        dismissKeyboardFromSearch()
    }
    
    @objc func dismissKeyboardFromSearch() {
        searchBar.endEditing(true)
        view.removeGestureRecognizer(self.tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 2 - 15
        let height = (width - 20) / 3 * 4
        return CGSize(width: width, height: height + 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: CGFloat(searchBarHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return searchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ExploreCell
    
        // Configure the cell
        //cell.backgroundColor = .red
        if !isSearching {
            
            cell.likebtn.addTarget(self, action: #selector(likeBtnTapped), for: .touchUpInside)
            
            cell.posterImage.image = nil
            
            cell.likebtn.imageView?.image = UIImage(named: "heart33")
            
            cell.poster = searchResult[indexPath.item]
            
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == alreadyLoadedSearchResult - 1 {
            if let text = searchBar.text, text.count != 0 {
                searchForPosters(keyword: text, from: alreadyLoadedSearchResult)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selecting: \(indexPath.item)")
        let newL = PosterDetailLauncher()
        newL.exitGesture.edges = .left
        newL.exitGesture.addTarget(self, action: #selector(handleSwipe(_:)))
        newL.showPosterDetail(searchResult[indexPath.item])
        originC = newL.mainV?.center
        originalPoster = searchResult[indexPath.item]
    }
    
    var originC: CGPoint?
    
    @objc func handleSwipe(_ sender: UIScreenEdgePanGestureRecognizer) {
        BtnActions().handleSwipe(sender, originC: originC!, frame: (collectionView?.frame)!)
    }
    
    @IBAction func likeBtnTapped(sender: UIButton!) -> Void {
        BtnActions().likeBtnTapped(sender: sender)
    }

}
