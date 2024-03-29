//
//  UIImageViewExtension.swift
//  Task Afiniti
//
//  Created by Muhammad Danish Qureshi on 5/7/21.
//

import Foundation
import UIKit
extension UIImage {
    func fixedOrientation() -> UIImage {
        // No-op if the orientation is already correct
        if (imageOrientation == UIImage.Orientation.up) {
            return self
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity

        if (imageOrientation == UIImage.Orientation.down
            || imageOrientation == UIImage.Orientation.downMirrored) {

            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }

        if (imageOrientation == UIImage.Orientation.left
            || imageOrientation == UIImage.Orientation.leftMirrored) {

            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        }

        if (imageOrientation == UIImage.Orientation.right
            || imageOrientation == UIImage.Orientation.rightMirrored) {

            transform = transform.translatedBy(x: 0, y: size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi / 2));
        }

        if (imageOrientation == UIImage.Orientation.upMirrored
            || imageOrientation == UIImage.Orientation.downMirrored) {

            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }

        if (imageOrientation == UIImage.Orientation.leftMirrored
            || imageOrientation == UIImage.Orientation.rightMirrored) {

            transform = transform.translatedBy(x: size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }

        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx:CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                                      bitsPerComponent: cgImage!.bitsPerComponent, bytesPerRow: 0,
                                      space: cgImage!.colorSpace!,
                                      bitmapInfo: cgImage!.bitmapInfo.rawValue)!

        ctx.concatenate(transform)

        if (imageOrientation == UIImage.Orientation.left
            || imageOrientation == UIImage.Orientation.leftMirrored
            || imageOrientation == UIImage.Orientation.right
            || imageOrientation == UIImage.Orientation.rightMirrored
            ) {
            ctx.draw(cgImage!, in: CGRect(x:0,y:0,width:size.height,height:size.width))
        } else {
            ctx.draw(cgImage!, in: CGRect(x:0,y:0,width:size.width,height:size.height))
        }

        // And now we just create a new UIImage from the drawing context
        let cgimg:CGImage = ctx.makeImage()!
        let imgEnd:UIImage = UIImage(cgImage: cgimg)

        return imgEnd
    }
}
