//
//  PhotoCollectionDataSource.swift
//  CameraFiltering
//
//  Created by Mohamed osama on 24/06/2021.
//

import Foundation
import UIKit

class PhotoCollectionCell: UICollectionViewCell{
    
    @IBOutlet weak var photoImageView: UIImageView!
    var delegate: PhotosDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageViewTarget()
        
    }
    
    func setupImageViewTarget(){
        photoImageView.isUserInteractionEnabled = true
        let tabGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePhotoImageTapped))
        photoImageView.addGestureRecognizer(tabGestureRecognizer)
        
    }
    
    @objc func handlePhotoImageTapped(){
        if let delegate = self.delegate{
            guard let indexPath = self.indexPath else {return}
            delegate.selectPhoto(indexPath: indexPath)
        }
    }
    
}
