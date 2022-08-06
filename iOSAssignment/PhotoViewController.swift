//
//  PhotoViewController.swift
//  iOSAssignment
//
//  Created by Vikas Kumar on 06/08/22.
//

import UIKit
import iOSPhotoEditor

class PhotoViewController: UIViewController {

    @IBOutlet weak var cameraImageView: UIImageView!
    
    //MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Action Methods
    @IBAction func didTapCameraButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerVC = UIImagePickerController()
            pickerVC.sourceType = .camera
            pickerVC.delegate = self
            self.present(pickerVC, animated: true, completion: nil)
        } else {
            debugPrint("Simulator doesn't have camera")
        }
    }
    
    @IBAction func didTapSavePhotoButton(_ sender: UIButton) {
        guard let selectedImage = cameraImageView.image else {
            debugPrint("Image not found!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    //MARK: - Private Helper Methods
    fileprivate func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    fileprivate func loadPhotoEditor(with image: UIImage) {
        let photoEditorVC = PhotoEditorViewController(nibName:"PhotoEditorViewController", bundle: Bundle(for: PhotoEditorViewController.self))
        photoEditorVC.photoEditorDelegate = self
        photoEditorVC.image = image
        present(photoEditorVC, animated: true)
    }
}

//MARK: - Image Delegate Methods
extension PhotoViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false)
        if let image = info[.originalImage] as? UIImage {
            loadPhotoEditor(with: image)
        }
    }
}

extension PhotoViewController: PhotoEditorDelegate {
    func doneEditing(image: UIImage) {
        // the edited image
        cameraImageView.image = image
    }
        
    func canceledEditing() {
        debugPrint("Cancelled")
    }

}
