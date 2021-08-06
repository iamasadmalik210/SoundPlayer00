//
//  ImageViewController.swift
//  SoundPlayer
//
//  Created by Asad on 05/08/2021.
//

import UIKit
import RealmSwift

class ImageViewController: UIViewController {
    var realm = try! Realm()
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        
        return imageView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(imageView)
        view.backgroundColor = .green
        
//        APIManager.shared.loadImage(with: "fire-texture_myQkHb.jpg"){ result in
//            switch result {
//
//
//            case .success(let data):
//
//                self.imageView.image = UIImage(data: data)
//                print(data)
//            case .failure(let error):
//                print(error)
//            }
//        }
//        
        loadImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.center = view.center
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    }
    private func loadImage(){
        let data = realm.objects(ImageSaver.self).first
        
        guard let imageData = data?.imageData else{
            print("image error")
            return
        }
        
        let myImage = UIImage(data: imageData)
        imageView.image = myImage
        
        print("image laoded")
        
    }
}
