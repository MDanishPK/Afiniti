//
//  ViewController.swift
//  Task Afiniti
//
//  Created by Muhammad Danish Qureshi on 5/7/21.
//

import UIKit
import Photos
import Firebase
import FirebaseStorage

class ViewController: UIViewController {
    // MARK: - Outlets

    // MARK: - Variables
    var imagePickerController = UIImagePickerController()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
    // MARK: - Helper Methods
    private func configure() {
        imagePickerController.delegate = self
        checkPermission()
    }
    private func checkPermission() {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({status in

            })
        }
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    private func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {

        } else {
            let alert  = UIAlertController(title: "Warning", message: "We don't have permission to access Photos.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:  { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func uploadToGoogleCloud(fileURL: URL) {
        
    }
    // MARK: - ACtions and Listeners
    @IBAction func uploadButtonClicked(_ sender: UIButton) {
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func downloadButtonClicked(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let wallet = storyBoard.instantiateViewController(withIdentifier: "DownloadViewController")
        wallet.modalPresentationStyle = .fullScreen
        if #available(iOS 13.0, *) {
            wallet.modalPresentationStyle = .automatic
        } else {
            wallet.modalPresentationStyle = .fullScreen
            // Fallback on earlier versions
        }
        self.present(wallet, animated: true, completion: nil)
    }
}
// MARK: - ImagePickerController
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[.imageURL] as? URL {
            if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
                let assetResources = PHAssetResource.assetResources(for: asset)
                print(assetResources.first!.originalFilename)
                FirebaseManager.shared.uploadImageToGoogleCloud(fileURL: url, fileName: assetResources.first!.originalFilename)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
