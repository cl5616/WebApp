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

class PostViewController: UIViewController, UINavigationControllerDelegate,
    UITextFieldDelegate {

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var previewImage: PostImagesView!
    @IBOutlet weak var expireDate: UITextField!
    
    var selectedAssets = [PHAsset]()
    var selectedPhotos = [UIImage]()
    
    let datePicker = UIDatePicker()


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewController: PostDetailsViewController = segue.destination as! PostDetailsViewController
        
        destViewController.selectedPhotos = selectedPhotos
        destViewController.titleText = titleTextField.text!
        destViewController.expDate = expireDate.text ?? ""
    }
    
    @IBAction func selectPressed(_ sender: Any) {
        selectedAssets = []
        selectedPhotos = []
        let mulPicker = BSImagePickerViewController()
        mulPicker.maxNumberOfSelections = 3

        self.bs_presentImagePickerController(mulPicker, animated: true, select: { (asset: PHAsset) -> Void in

        }, deselect: { (asset: PHAsset) -> Void in

        }, cancel: { (assets: [PHAsset]) -> Void in

        }, finish: { (assets: [PHAsset]) -> Void in

            for i in 0..<assets.count {
                self.selectedAssets.append(assets[i])
            }
            self.convertAssetsToImages()
        }, completion: nil)
    }

    func convertAssetsToImages() -> Void {
        if selectedAssets.count != 0 {
            DispatchQueue.main.sync {
                nextButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true)
            }
            for i in 0..<selectedAssets.count {
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                option.isSynchronous = true

                manager.requestImage(for: selectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: {(result, info) -> Void in thumbnail = result!
                })

                let data = UIImageJPEGRepresentation(thumbnail, 1)
                let newImage = UIImage(data: data!)
                self.selectedPhotos.append(newImage! as UIImage)
            }

            previewImage.selectedPhotos = self.selectedPhotos
            DispatchQueue.main.async {
                self.previewImage.cv.reloadData()
            }
        }
    }

    @IBAction func nextPressed(_ sender: Any) {

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        nextButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !self.selectedPhotos.isEmpty
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nextButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !self.selectedPhotos.isEmpty
    }

    @objc func keyboardWillChange(notification: Notification) {
        guard let keyBoardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame {

            view.frame.origin.y = -keyBoardRect.height + (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.size.height
        } else {
            view.frame.origin.y = 0
        }

    }
    
    func createDataPicker() {
        let tb = UIToolbar()
        tb.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelPressed))
        
        tb.setItems([done, cancel], animated: false)
        expireDate.inputAccessoryView = tb
        expireDate.inputView = datePicker
        
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .dateAndTime
    }
    
    @objc func cancelPressed() {
        expireDate.text = ""
        self.view.endEditing(true)
    }

    @objc func donePressed() {
        
        /*let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        let dateStr = formatter.string(from: datePicker.date)
        */
        
        expireDate.text = "\(datePicker.date)"//dateStr
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

        titleTextField.delegate = self
        self.navigationItem.rightBarButtonItem = nextButton
        createDataPicker()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

}
