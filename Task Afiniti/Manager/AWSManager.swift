//
//  AWSManager.swift
//  Task Afiniti
//
//  Created by Muhammad Danish Qureshi on 5/7/21.
//

import Foundation
import UIKit
import AWSS3
import AWSCore

typealias progressBlock = (_ progress: Double) -> Void
typealias completionBlock = (_ response: Any?, _ error: Error?) -> Void

class AWSManager: NSObject {
    static let shared = AWSManager()
    let S3BucketName = AWSDirectory.bucketName
    let progressView = UIProgressView(progressViewStyle: .default)
    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//UIApplication.shared.keyWindow!
    var progressContainerView = UIView()
    func initializeS3() {
        let secretKey = AWSDirectory.secretKey
        let accessKey = AWSDirectory.accessKey
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let configuration = AWSServiceConfiguration(region:AWSRegionType.USEast2, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }

    func addProgressViewOnWindow() {
        progressContainerView = UIView(frame: CGRect(x: 20, y: 20, width: window?.frame.width ?? 0 - 40, height: 10))
        progressView.frame = CGRect(x: 0, y: 0, width: window?.frame.width ?? 0 - 40, height: 10)
        progressContainerView.addSubview(progressView)
        progressContainerView.backgroundColor = UIColor.clear
        window?.addSubview(progressContainerView)
    }

    func uploadImage(image: UIImage, on diretory: String = "", progress: progressBlock?, completion: completionBlock?) {

        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            completion?(nil, error)
            return
        }

        let tmpPath = NSTemporaryDirectory() as String
        let fileName: String = ProcessInfo.processInfo.globallyUniqueString + (".jpeg")
        let filePath = tmpPath + "/" + fileName
        let fileUrl = URL(fileURLWithPath: filePath)

        do {
            try imageData.write(to: fileUrl)
            var fileNameWithDirectory = "\(diretory)-\(fileName)"

            fileNameWithDirectory = fileNameWithDirectory.replacingOccurrences(of: " ", with: "_")
            fileNameWithDirectory = fileNameWithDirectory.replacingOccurrences(of: "+", with: "_")
            fileNameWithDirectory = fileNameWithDirectory.replacingOccurrences(of: "-", with: "_")
            print(fileNameWithDirectory)

            self.uploadfile(fileUrl: fileUrl, fileName: fileNameWithDirectory, contenType: "image/jpeg", progress: progress, completion: completion)
        } catch {
            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
            completion?(nil, error)
        }
    }

    private func uploadfile(fileUrl: URL, fileName: String, contenType: String, progress: progressBlock?, completion: completionBlock?) {
        // Upload progress block
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, awsProgress) in
            guard let uploadProgress = progress else { return }
            DispatchQueue.main.async {
                uploadProgress(awsProgress.fractionCompleted)
//                self.addProgressViewOnWindow()
//                self.progressView.setProgress(Float(awsProgress.fractionCompleted), animated: true)
            }
        }
        // Completion block
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
//            DispatchQueue.main.async {
//                self.progressContainerView.removeFromSuperview()
//            }
            DispatchQueue.main.async(execute: {


                if error == nil {
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(self.S3BucketName).appendingPathComponent(fileName)
                    print("Uploaded to:\(String(describing: publicURL))")
                    if let completionBlock = completion {
                        completionBlock(publicURL?.absoluteString, nil)
                    }
                } else {
                    if let completionBlock = completion {
                        completionBlock(nil, error)
                    }
                }
            })
        }
        // Start uploading using AWSS3TransferUtility
        let awsTransferUtility = AWSS3TransferUtility.default()
        awsTransferUtility.uploadFile(fileUrl, bucket: S3BucketName, key: fileName, contentType: contenType, expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
            if let error = task.error {
                print("error is: \(error.localizedDescription)")
            }
            if let _ = task.result {
                // your uploadTask
            }
            return nil
        }
    }
}
