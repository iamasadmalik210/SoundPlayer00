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
    
//    let viewModels = [SoundsModel(image: UIImage(named: "image1"), title: "Chal Wahan", subtitle: "Arijit Singh",music: "01. We Made It"),SoundsModel(image: UIImage(named: "image1"), title: "Chal Wahan", subtitle: "Arijit Singh",music: "08. Come Through (feat. Chris Brown)"),SoundsModel(image: UIImage(named: "image2"), title: "Chal Wahan", subtitle: "Arijit Singh",music: "We Made It"),SoundsModel(image: UIImage(named: "image4"), title: "Chal Wahan", subtitle: "Arijit Singh", music: "We Made It"),SoundsModel(image: UIImage(named: "image1"), title: "Chal Wahan", subtitle: "Arijit Singh",music: "We Made It"),SoundsModel(image: UIImage(named: "image1"), title: "Chal Wahan", subtitle: "Arijit Singh",music: "We Made It"),SoundsModel(image: UIImage(named: "image3"), title: "Chal Wahan", subtitle: "Arijit Singh",music: "We Made It"),SoundsModel(image: UIImage(named: "image1"), title: "Chal Wahan", subtitle: "Arijit Singh",music: "We Made It")]
    var viewModels = [Songs]()
    var myViewModels : [Songs]?
    
    var newSongsModels : [NewSoundData]?
    
    
    var realm = try! Realm()

    private let tableView : UITableView = {
       let tableView = UITableView()
        
        
        tableView.register(SoundsTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = SearchView(frame: CGRect(x: 0, y: 0, width: tableView.width, height: 50))
        
        return tableView
        
        
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .green
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.isNavigationBarHidden = true
        
        
        
        // Fetching Data using APIManager
        fetchingData()
        

        
        
        loadingImage()


        
    }
    
    private func fetchingImage() -> UIImage{
        print("Fetching image")
        
        var myImage : UIImage?
        
        
        let x = 0
        
        print(myViewModels)
        
        
        
        APIManager.shared.loadImage(with: (myViewModels?[0].song_image)!) { result in

            switch result {


            case .success(let data):
                
                myImage = data
                myImage = data
                DispatchQueue.main.async {
                    print("refreshing UI")
                }

            case .failure(let error):
                print(error)
            }


            }
        guard let newImage = myImage else{
            print("imag error ")
            fatalError()
        }

        return newImage
    }
    
    public func loadingImage(){
        
        let data = realm.objects(SongsDatabase.self)
        
        print("Printing Data using realm objects")
        print(data)
    }
    
    
    
//    private func loadObjects(){
//
//        let data = realm.objects(SongsDatabase.self)
//
//        print("loading objects from realm swift")
//        print(data)
//
//    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    public func fetchingData(){
        
        print("Getting Response from APIManager")
        APIManager.shared.getSongs { result in
            
            switch result {
            
            
            case .success(let data):
                print("Printing Dataa")
//                print(data)
                
                self.myViewModels = data.songs
              
                DispatchQueue.main.async {
//                  let image =  self.fetchingImage()
//                    print("fetching iamge method called")
//                    print(image)

                    self.setUpTableView()
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
        self.viewModels = viewModels
        tableView.reloadData()
        
    }
    
}

extension SoundViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        print(viewModels.count)
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as? SoundsTableViewCell else {
            fatalError()
        }
        
        
        cell.configure(viewModels: viewModels[indexPath.row])
       
      
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
   let data = viewModels[indexPath.row]
        print("Current Data")
        print(data)
        
        let vc = PlayerViewController()
        vc.newData = data
        vc.newImage = tableView.cellForRow(at: indexPath)?.imageView?.image
        navigationController?.pushViewController(vc, animated: true)
    }
}
