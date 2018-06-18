//
//  PosterDescriptionScrollView.swift
//  CollegePosters
//
//  Created by 姜曦 on 12/06/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit

class PosterDescriptionCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let idxToIdMap = [0: "user", 1: "content", 2: "comment", 3: "refresh"]
    let imageViewer = ImageViewer()
    var rc = UIRefreshControl()
    
    lazy var cvt: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    var poster: Poster? {
        didSet {
            DispatchQueue.main.async {
                self.cvt.reloadData()
            }
            alreadyLoadedComment = 0
            comments = [Comment]()
        }
    }
    
    var alreadyLoadedComment = 0
    var comments: [Comment] = [Comment]()
    var commentsId: [Int] = [Int]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cvt.register(PosterDetailUserCellCollectionViewCell.self, forCellWithReuseIdentifier: "user")
        cvt.register(PosterDetailContentCollectionViewCell.self, forCellWithReuseIdentifier: "content")
        cvt.register(PosterDetailsCollectionViewCell.self, forCellWithReuseIdentifier: "comment")
        
        cvt.refreshControl = rc
        rc.tintColor = .black
        rc.addTarget(self, action: #selector(refreshAllComments), for: .valueChanged)
        
        addSubview(cvt)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cvt]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cvt]))
        
        cvt.backgroundColor = .white
        backgroundColor = .brown
        
    }
    
    @objc func refreshAllComments() {
        if !isFetchingComment {
            print("refreshing all comments")
            fetchComment(postId: (poster?.postId)!, from: 0)
        }
    }
    
    func fetchComment(postId: Int, from: Int) {
        
        if from == 0 {
            comments = [Comment]()
            commentsId = [Int]()
            alreadyLoadedComment = 0
        }
        
        HttpApiService.sharedHttpApiService.fetchComment(postId: postId, from: from) { (comments) in
            self.sortComment(comments)
            //self.comments.append(contentsOf: comments)
            self.selectForRender(comments: comments)
            self.alreadyLoadedComment += comments.count
            self.isFetchingComment = false
            DispatchQueue.main.async {
                self.cvt.reloadData()
                self.rc.endRefreshing()
            }
        }
        
    }
    
    func sortComment(_ comments: [Comment]) {
        for comment in comments {
            if comment.replyUser == nil && comment.replyId != nil{
                for otherComment in comments {
                    if otherComment.commentId! == comment.replyId {
                        comment.replyUser = otherComment.commenterId
                        HttpApiService.sharedHttpApiService.fetchUserProfile(comment.replyUser!, completion: { (user) in
                            comment.replyUserProfile = user
                        })
                    }
                }
            }
        }
    }
    
    func selectForRender(comments: [Comment]) {
        for comment in comments {
            let newId = comment.commentId!
            if !commentsId.contains(newId) {
                self.comments.append(comment)
                commentsId.append(newId)
            }
        }
    }
    
    func heightForComments() -> CGFloat {
        
        var totalHeight: CGFloat = 0
        
        for comment in comments {
            let constraintRect = CGSize(width: frame.width - 56, height: .greatestFiniteMagnitude)
            let boundingBox = (comment.content! as NSString).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [:], context: nil)
            var height = ceil(boundingBox.height)
            height += 56
            totalHeight += height
        }
        
        return totalHeight
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var idx = indexPath.item
        if idx > 2 {
            idx = 2
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idxToIdMap[idx]!, for: indexPath)
        if idx == 0 {
            let cell = cell as! PosterDetailUserCellCollectionViewCell
            cell.poster = poster
        } else if idx == 1 {
            let cell = cell as! PosterDetailContentCollectionViewCell
            cell.poster = poster
            cell.cmtbtn.addTarget(self, action: #selector(cmtBtnTapped(sender:)), for: .touchUpInside)
        } else if idx == 2 && comments.count > 0{
            let cell = cell as! PosterDetailsCollectionViewCell
            cell.comment = comments[indexPath.item - 2]
            cell.cmtBtn.addTarget(self, action: #selector(cmtBtnTapped(sender:)), for: .touchUpInside)
            cell.cmtBtn.postId = poster?.postId
        }
        return cell
    }
    
    var isFetchingComment = false
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == alreadyLoadedComment + 1 && !isFetchingComment{
            cvt.cellForItem(at: IndexPath(item: 1, section: 1))?.clearsContextBeforeDrawing = true
            isFetchingComment = true
            fetchComment(postId: (poster?.postId)!, from: alreadyLoadedComment)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if showingUserDetail {
            dissmissUserDetail()
            return
        }
        
        if indexPath.item == 0 {
           showUserDetail()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if showingUserDetail {
            dissmissUserDetail()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = frame.width
        
        switch indexPath.item {
        case 0:
            return CGSize(width: width, height: 56)
        case 1:
            return CGSize(width: width, height: 200 + 35)
        default:
            if comments.count == 0 {
                return CGSize(width: width, height: 100)
            } else {
                let height = comments[indexPath.item - 2].content?.height(withConstrainedWidth: frame.width - 56)
                return CGSize(width: width, height: height! + 56 + 35)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if showingUserDetail {
            dissmissUserDetail()
        }
    }
    
    let action = CommentAction()
    
    @IBAction func cmtBtnTapped(sender: UIButton!) -> Void {
        action.showCommentEditor(sender)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let userDetailViewer = UserDetailLauncher()
    let dismissUserDetailGesture : UITapGestureRecognizer = {
        let g = UITapGestureRecognizer()
        g.addTarget(self, action: #selector(dissmissUserDetail))
        return g
    }()
    var showingUserDetail: Bool = false
    
    @objc func showUserDetail() {
        print("showing user detail")
        if let user = poster?.user {
            showingUserDetail = true
            userDetailViewer.showUserDetail(user: user)
        }
    }
    
    @objc func dissmissUserDetail() {
        print("dismissing user detail")
        showingUserDetail = false
        userDetailViewer.dismissView()
    }

}
