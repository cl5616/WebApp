//
//  PostViewController.swift
//  College Posters
//
//  Created by 姜曦 on 30/05/2018.
//  Copyright © 2018 姜曦. All rights reserved.
//

import UIKit
import Photos
import BSImagePicker

class PostViewController: UIViewController, /*UIImagePickerControllerDelegate,*/ UINavigationControllerDelegate,
    UITextFieldDelegate {
    
    
    
    //@IBOutlet weak var imageCollection: UICollectionView!
    //@IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var previewImage: PostImagesView!
    //    var picker = UIImagePickerController()

    var selectedAssets = [PHAsset]()
    var selectedPhotos = [UIImage]()
    
  /*  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.previewImage.image = image
            selectButton.isHidden = true
            self.nextButton.isEnabled = true
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }*/
    
    @IBAction func selectPressed(_ sender: Any) {
        
        /*picker.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.sourceType = .camera
                self.present(self.picker, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Invalid Photo Source", message: "No access to Camera.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)*/
        selectedAssets = []
        selectedPhotos = []
        let mulPicker = BSImagePickerViewController()
        
        self.bs_presentImagePickerController(mulPicker, animated: true, select: { (asset: PHAsset) -> Void in
            
        }, deselect: { (asset: PHAsset) -> Void in
            
        }, cancel: { (assets: [PHAsset]) -> Void in
            
        }, finish: { (assets: [PHAsset]) -> Void in
            
            for i in 0..<assets.count {
                self.selectedAssets.append(assets[i])
            }
            self.convertAssetsToImages()
        }, completion: nil)
        //self.selectButton.isHidden = true
        self.nextButton.isEnabled = true
    }
    
    func convertAssetsToImages() -> Void {
        if selectedAssets.count != 0 {
            
            var contentWidth: CGFloat = 0.0
            for i in 0..<selectedAssets.count {
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true
                
                manager.requestImage(for: selectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: {(result, info) -> Void in thumbnail = result!
                })
                
                let data = UIImageJPEGRepresentation(thumbnail, 0.7)
                let newImage = UIImage(data: data!)
                /*let newImageView = UIImageView(image: newImage)
                let xCoord = view.frame.midX + view.frame.width * CGFloat(i)
                scrollViewImages.addSubview(newImageView)
                contentWidth += scrollViewImages.frame.width
                newImageView.frame = CGRect(x: xCoord, y: scrollViewImages.frame.height / 2, width: scrollViewImages.frame.width, height: scrollViewImages.frame.height)*/
                self.selectedPhotos.append(newImage! as UIImage)
            }
            /*scrollViewImages.contentSize = CGSize(width: contentWidth, height: scrollViewImages.frame.height)
            */
            /*
            self.previewImage.animationImages = self.selectedPhotos
            self.previewImage.animationDuration = 3.0
            self.previewImage.startAnimating()
 */
            previewImage.selectedPhotos = self.selectedPhotos
            previewImage.cv.reloadData()
        }
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false
        //picker.delegate = self
        titleTextField.delegate = self
        self.navigationItem.rightBarButtonItem = nextButton
    }

}

class PostImageCell: UICollectionViewCell {
    
}
