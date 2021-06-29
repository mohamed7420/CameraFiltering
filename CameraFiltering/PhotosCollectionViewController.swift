//
//  PhotosCollectionViewController.swift
//  CameraFiltering
//
//  Created by Mohamed osama on 23/06/2021.
//

import Foundation
import UIKit
import Photos
import RxSwift

class PhotosCollectionViewController: UICollectionViewController{
    
    private var photos = [PHAsset]()
    private let selectPhotoSubject = PublishSubject<UIImage>()
    var selectedPhoto: Observable<UIImage>{
        return selectPhotoSubject.asObserver()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populatePhotos()
    }
    
    private func populatePhotos(){
        PHPhotoLibrary.requestAuthorization{ [weak self] status in
            if status == .authorized{
                let asset = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                asset.enumerateObjects{(object , count , stop) in

                    guard let self = self else {return}
                    self.photos.append(object)
                    print(self.photos)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }else{
                print("Not Authorized")
            }
        }
    }
    
}

extension PhotosCollectionViewController : PhotosDelegate{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as! PhotoCollectionCell
        cell.delegate = self
        cell.indexPath = indexPath
        let asset = self.photos[indexPath.row]
        let photoManager = PHImageManager.default()
        photoManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { (image, _) in
            DispatchQueue.main.async {
                cell.photoImageView.image = image
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
    }
    
    func selectPhoto(indexPath: IndexPath) {
        let selectedAsset = self.photos[indexPath.row]
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) {[weak self] (image, info) in
            guard let info = info , let self = self else {return}
            
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Int
            if isDegradedImage != 1{
                if let image = image{
                    self.selectPhotoSubject.onNext(image)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}
