//
//  ViewController.swift
//  CameraFiltering
//
//  Created by Mohamed osama on 23/06/2021.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var selectedImageView: UIImageView!
    let disposedBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    @IBAction func applyFilterAction(_ sender: UIButton) {
        guard let image = self.selectedImageView.image else {return}
        FilterService().applyFilter(to: image).subscribe(onNext: { filteredImage in
            DispatchQueue.main.async {
                self.selectedImageView.image = filteredImage
            }
        }).disposed(by: disposedBag)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navC = segue.destination as? UINavigationController , let vc = navC.viewControllers.first as? PhotosCollectionViewController{
            vc.selectedPhoto.subscribe { [weak self](image) in
                DispatchQueue.main.async {
                    self?.selectedImageView.image = image
                }
            }.disposed(by: disposedBag)
        }
    }
    
}

