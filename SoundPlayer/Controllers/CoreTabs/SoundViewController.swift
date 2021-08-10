//
//  SoundViewController.swift
//  SoundPlayer
//
//  Created by Asad on 03/08/2021.
//

import UIKit
import RealmSwift
import SDWebImage

class SoundViewController: UIViewController {
    
    // Vars
    var viewModels = [Songs]()
    
    var myViewModels : [SongsDatabase]?
    
    var newSongsModels : [NewSoundData]?
    //    var newArray = [SongsDatabase]()
    var myArray : Results<SongsDatabase>?
    
    
    
    var realm = try! Realm()
    
    
    // MARK: UI's
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        
        
        tableView.register(SoundsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = SearchView(frame: CGRect(x: 0, y: 0, width: tableView.width, height: 50))
        
        return tableView
        
        
        
    }()
    
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.color = .red
        
        
        return spinner
        
    }()
    
    
    // MARK: Life Cycle Methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try! realm.write({
                self.realm.deleteAll()
            })
        }
        
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .green
        view.addSubview(tableView)
        
        view.addSubview(spinner)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.addSubview(spinner)
        
        navigationController?.isNavigationBarHidden = true
        
        
        
        // Fetching Data using APIManager
        spinner.startAnimating()
        fetchingData()
        
        
        
        //        loadingImage()
        
        //
        
        // MARK: For Checking Purpose
        //        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
        //            let vc = ImageViewController()
        //            self.present(vc, animated: true, completion: nil)
        //        }
        
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        spinner.center = tableView.center
    }
    
    
    
    
    
    // MARK: Fetching Image
    var id : String?
    
    private func fetchingImage(with string : String) {
        
        id = UUID().uuidString
        print("Fetching image")
        
        //        var myImage : UIImage?
        
        // Image API Call
        
        
        guard let storeArray = myArray else {
            return
        }
        APIManager.shared.loadImage(with: string) { result in
            
            
            switch result {
            
            
            
            
            case .success(let image):
                
                
                //                self.store(image: self.image.image!, forKey: self.id, withStorageType: .fileSystem)
                
                DispatchQueue.main.async {
                    
                    for x in 0...storeArray.count - 1{
                        if self.imageArray.count == nil{
                            
                                                  self.store(image: image, forKey: "imagee\(x)", withStorageType: .fileSystem)
                        }
                      
                        
                    }
                    
                    
                    
                    
                }
                
                
                
                
                
                
            //                print(image)
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    var imageArray = [Image]()
    
    
    private func viewImage() {
        
        print(myArray?.count)
        
        guard let myArray = myArray else {
            return
        }
        
      
            for x in 0...myArray.count - 1{
                guard let image = self.retrieveImage(forKey: "imagee\(x)", inStorageType: .fileSystem) else {
                    
                    print("Image Error")
                    return
                }
                imageArray.append(Image(image: image))
                
            }
       
        
        
        print(imageArray.count)
        print(imageArray)
            self.tableView.reloadData()
        }
        
        
        
        
        
        
      
        

    
    
    
    
    
    
    
    
    
    
    
    public func fetchingData(){
        
        // MARK: API Calls
        
        print("Getting Response from APIManager")
        APIManager.shared.getSongs { result in
            
            switch result {
            
            
            case .success(let data):
                
                
                self.myViewModels = data.songs
                
                //                print(self.myViewModels)
                
                DispatchQueue.main.async {
                    
                    
                    //
                    
                    self.setUpTableView()
                    self.spinner.stopAnimating()
                    
                }
                
            case .failure(let error):
                print("Printing Error")
                print(error)
            }
        }
    }
    
    
    
    
    private func setUpTableView(){
        
        guard let viewModels = self.myViewModels else {
            print("Empty Value")
            return
        }
        
        var songsDatabase  = RealmSongs()
        
        var myData = SongsDatabase()
        
        
        //TODO:  if songs.id == myviewmodels.id .. stop uploading to ream
        // MARK: Adding Data into Realm Database
        try! realm.write({
            //
            songsDatabase.songsDatabase.append(objectsIn: viewModels )
            realm.add(songsDatabase,update: .modified)
            print("Done Adding")
            
        })
        loadData()
        
        
        
        
    }
    
    
    
    private func loadData(){
        
        let data = self.realm.objects(SongsDatabase.self)
        
        print(data.count)
        
        
        myArray = data
        
        print("My Array")
        
        
        print(myArray)
        
        guard let array = myArray else{
            return
        }
        
        for x in 0...array.count - 1 {
            
            
            
            fetchingImage(with: (array[x].song_image!))
            
        }
        
        self.viewImage()
        tableView.reloadData()
        
    }
    
    
    
    
    
    
    //    MARK:- FOR STORING IMAGE LOCALLY
    
    enum StorageType {
        case userDefaults
        case fileSystem
    }
    
    public func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".png")
    }
    
    
    public func store(image: UIImage, forKey key: String, withStorageType storageType: StorageType ) {
        if let pngRepresentation = image.pngData() {
            switch storageType {
            
            case .fileSystem:
                if let filePath = filePath(forKey: key) {
                    do  {
                        try pngRepresentation.write(to: filePath,
                                                    options: .atomic)
                        
                    } catch let err {
                        print("Saving file resulted in error: ", err)
                    }
                }
                
            case .userDefaults:
                
                UserDefaults.standard.set(pngRepresentation, forKey: key)
            }
        }
    }
    
    
    public func retrieveImage(forKey key: String, inStorageType storageType: StorageType) -> UIImage? {
        switch storageType {
        
        
        case .fileSystem:
            if let filePath = self.filePath(forKey: key),
               let fileData = FileManager.default.contents(atPath: filePath.path),
               let image = UIImage(data: fileData) {
                return image
            }
        case .userDefaults:
            if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
               let image = UIImage(data: imageData) {
                
                return image
                
            }
            
            
            
        }
        
        return nil
    }
    
    
    //
    var songString = [String]()
    
    
    private func storeImage(with string:String){
        
        SDWebImageManager.shared.loadImage(
            with: URL(string: "http://collections.codecture.co/assets/upload_images/\(string)"),
            options: .continueInBackground, // or .highPriority
            progress: nil,
            completed: { [weak self] (image, data, error, cacheType, finished, url) in
                guard let sself = self else { return }
                if let err = error {
                    // Do something with the error
                    return
                }
                
                guard let img = image else {
                    // No image handle this error
                    return
                }
                
                // Do something with image
                
                print(image)
            }
        )
    }
}

extension SoundViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        print(viewModels.count)
        return myArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as? SoundsTableViewCell else {
            fatalError()
        }
        //
        print(imageArray.count)
        
        cell.configure(viewModels: myArray![indexPath.row])
        //
//
//        if indexPath.row <= imageArray.count
//        {
//
//            cell.configureImage(viewModels: imageArray[indexPath.row])
//        }
//        else if imageArray.count == nil {
//            print("ERROR")
//        }
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = myArray?[indexPath.row]
        print("Current Data")
        
        let vc = PlayerViewController()
        vc.newData = data
        vc.newImage = tableView.cellForRow(at: indexPath)?.imageView?.image
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
}

