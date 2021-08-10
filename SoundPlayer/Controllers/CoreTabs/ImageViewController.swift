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
//        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFit
        return imageView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(imageView)
        view.backgroundColor = .green
 
        APIManager.shared.loadImage(with: "storyblocks-beautiful-anse-intendance-tropical-beach-ocean-wave-roll-on-sandy-beach-with-coconut-palm-trees-mahe-seychelles_SsGl-XA92N.jpg") { result in
            
            switch result {
            
            case .success(let image):
                print("the image we got === \(image)")
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
                
            case .failure(let error):
                print(error)
            }
        }}
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.center = view.center
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    }

        
        
        
        
       // "http://collections.codecture.co/assets/upload_images/storyblocks-beautiful-anse-intendance-tropical-beach-ocean-wave-roll-on-sandy-beach-with-coconut-palm-trees-mahe-seychelles_SsGl-XA92N.jpg"
        
        
        
        

    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            print(data)
            DispatchQueue.main.async() { [weak self] in
                        self?.imageView.image = UIImage(data: data)
                    }
            
        }
}
}
