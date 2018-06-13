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
            alreadyLoadedComment = 0
            comments = [Comment]()
        }
    }
    
    var alreadyLoadedComment = 0
    var comments: [Comment] = [Comment]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cvt.register(PosterDetailUserCellCollectionViewCell.self, forCellWithReuseIdentifier: "user")
        cvt.register(PosterDetailContentCollectionViewCell.self, forCellWithReuseIdentifier: "content")
        cvt.register(PosterDetailCommentCollectionViewCell.self, forCellWithReuseIdentifier: "comment")
        cvt.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "refresh")
        
        addSubview(cvt)
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cvt]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": cvt]))
        
        cvt.backgroundColor = .white
        backgroundColor = .brown
        
    }
    
    func fetchComment() {
        for i in 1...5 {
            let newC = Comment()
            newC.commenterId = i + alreadyLoadedComment
            newC.replyId = 1
            newC.commentId = i + alreadyLoadedComment
            newC.commentTime = "example Time"
            newC.content = "sample contentfaksjdfka sl;dfklkf a;klsdfkl nas;ldnf lncjlvjz;xj ;afsa;kdlfjkasjd;klf  fjlkdjf asdf asd fsd  fasd fasdf asdf asdf asdf adnsdf lkajsk;ldn cklnxcjlvfasdlkjf kalsjkln lk;vlakj ;klansdml flnks dvjlclvl anlsd mkcvl ckljvkl; sklnf asjkldnf joajdk;lf nalsdn fljankc;vklac ;lma jofn nzl;k nj"
            comments.append(newC)
        }
        alreadyLoadedComment += 5
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
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let idx = indexPath.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idxToIdMap[idx]!, for: indexPath)
        
        if idx == 1 {
            let cell = cell as! PosterDetailContentCollectionViewCell
            cell.poster = poster
            cell.cmtbtn.addTarget(self, action: #selector(cmtBtnTapped(sender:)), for: .touchUpInside)
        } else if idx == 2 {
            let cell = cell as! PosterDetailCommentCollectionViewCell
            cell.comments = comments
            for btn in cell.cmbBtns {
                btn.addTarget(self, action: #selector(cmtBtnTapped(sender:)), for: .touchUpInside)
                btn.postId = poster?.postId
            }
        } else if idx == 3 {
            cell.backgroundColor = .cyan
        }
        
        cell.sizeToFit()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == 3 {
            fetchComment()
            DispatchQueue.main.async {
                self.cvt.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = frame.width
        
        switch indexPath.item {
        case 0:
            return CGSize(width: width, height: 56)
        case 1:
            return CGSize(width: width, height: 200)
        case 2:
            if comments.count == 0 {
                return CGSize(width: width, height: 50)
            } else {
                let height = heightForComments()
                return CGSize(width: width, height: height)
            }
        default:
            return CGSize(width: width, height: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @IBAction func cmtBtnTapped(sender: UIButton!) -> Void {
        let btn = sender as! CommentBtn
        if btn.isReply! {
            print("cmt button pressed: replying \(btn.commentId!) on \(btn.postId!)")
        } else {
            print("cmt button pressed: commenting on \(btn.postId!)")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
