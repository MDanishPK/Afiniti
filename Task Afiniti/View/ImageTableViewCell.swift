//
//  ImageTableViewCell.swift
//  Task Afiniti
//
//  Created by Muhammad Danish Qureshi on 5/7/21.
//

import UIKit
import FirebaseUI
protocol ImageTableViewCellDelegate {
    func transferThis(image: UIImage)
}
class ImageTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var downLoadimageView: UIImageView!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet weak var progressLabel: UILabel!

    @IBOutlet weak var delegateButton: UIButton!
    // MARK: - Variables
    var delegate: ImageTableViewCellDelegate?

    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func startDownload(image: Int) {
        activityLoader.startAnimating()
        self.progressLabel.text = "Image Name: \(image) downloading"
        progressLabel.numberOfLines = 0
        FirebaseManager.shared.downloadImageFromGoogleCloud(fileNumber: image, imageView: downLoadimageView, completed: progressLabel ) { (succes, storageReference)   in
            DispatchQueue.main.async {
                self.activityLoader.isHidden = true
                self.progressLabel.text = "Image Name: \(image) Completed"
                storageReference.downloadURL { (url, error) in
                    guard let url = url else {return}
                    print("URL:\(url)")
                    self.progressLabel.text = "Image Name: \(image) Completed\n\n Click to share\n\n url:\(url)"
                }
            }
        }
    }
    @IBAction func delegateButtonClicked(_ sender: UIButton) {
        guard let image = downLoadimageView.image else {
            return
        }
        delegate?.transferThis(image: image)
    }
}
