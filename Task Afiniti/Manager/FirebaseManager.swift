//
//  FirebaseManager.swift
//  Task Afiniti
//
//  Created by Muhammad Danish Qureshi on 5/7/21.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseManager {
    static let shared = FirebaseManager()
    let storage = Storage.storage()
    func uploadImageToGoogleCloud(fileURL: URL, fileName: String) {
        _ = Data()
        let storageRef = storage.reference()
        let localFile = fileURL
        let value = UserStorage().getCounter()
        let imagesRef = storageRef.child("images/\(value)")
        let uploadTask = imagesRef.putFile(from: localFile, metadata: nil)
        uploadTask.observe(.resume) { snapshot in
          // Upload resumed, also fires when the upload starts
            print("Resume")
        }
        uploadTask.observe(.pause) { snapshot in
          // Upload paused
            print("Pause")
        }
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print("Progress:\(percentComplete)")
        }
        uploadTask.observe(.success) { metadata in
            print("uploaded")
            let value = UserStorage().getCounter()
            UserStorage().set(counter: value + 1)
            print("Value:\(value)")
        }
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    print("objectNotFound")
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    print("unauthorized")
                    break
                case .cancelled:
                    // User canceled the upload
                    print("cancelled")
                    break
                /* ... */
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    print("unknown")
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    print("default")
                    break
                }
            }
        }
    }
    func downloadImageFromGoogleCloud(fileNumber: Int, imageView: UIImageView, completed: UILabel, progress: @escaping(_ status: Bool, StorageReference) -> () ) {
        let storageRef = storage.reference()
        let localURL = URL(string: "path/to/image")!
        // Create a reference to the file we want to download
        let starsRef = storageRef.child("images/\(fileNumber)")
        // Start the download (in this case writing to a file)
        let downloadTask = storageRef.write(toFile: localURL)
        // Observe changes in status
        downloadTask.observe(.resume) { snapshot in
            // Download resumed, also fires when the download starts
            print("Resume")
        }
        downloadTask.observe(.pause) { snapshot in
            // Download paused
            print("Pause")
        }

        downloadTask.observe(.progress) { snapshot in
            // Download reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print("Progress:\(percentComplete)")
            imageView.sd_setImage(with: starsRef)
            DispatchQueue.main.async {
                completed.text = "\(percentComplete) completed"
            }
            progress(true, starsRef)
        }

        downloadTask.observe(.success) { snapshot in
            // Download completed successfully
            print("Success:\(snapshot)")
        }

        // Errors only occur in the "Failure" case
        downloadTask.observe(.failure) { snapshot in
            guard let errorCode = (snapshot.error as NSError?)?.code else { return }
            guard let error = StorageErrorCode(rawValue: errorCode) else { return }
            switch (error) {
            case .objectNotFound:
                // File doesn't exist
                print("objectNotFound")
                break
            case .unauthorized:
                // User doesn't have permission to access file
                print("unauthorized")
                break
            case .cancelled:
                // User canceled the upload
                print("cancelled")
                break
            /* ... */
            case .unknown:
                // Unknown error occurred, inspect the server response
                print("unknown")
                break
            default:
                // A separate error occurred. This is a good place to retry the upload.
                print("default")
                break
            }
        }
    }
}
