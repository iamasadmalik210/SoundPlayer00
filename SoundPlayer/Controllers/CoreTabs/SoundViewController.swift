//
//  SoundViewController.swift
//  SoundPlayer
//
//  Created by Asad on 03/08/2021.
//

import UIKit
import RealmSwift
import AVFoundation
class SoundViewController: UIViewController {
    
    // Vars
    
    var playerView = PlayerView()
    var viewModels = [Songs]()
    
    var myViewModels : [SongsDatabase]?
    
    var newSongsModels : [NewSoundData]?
    //    var newArray = [SongsDatabase]()
    var realmDataArray : Results<SongsDatabase>?
    //        var myArray : [SongsDatabase]?
    var audioPlayer : AVAudioPlayer!
    
    var searchView = SearchView()
    
    
    
    var realm = try! Realm()
    
    
    // MARK: UI's
    
    private let tableView : UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        
        tableView.register(SoundsTableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.tableHeaderView = SearchView(frame: CGRect(x: 0, y: 0, width: tableView.width, height: 50))

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
//        playerView.isHidden = true

        playerView.delegate = self
        view.addSubview(playerView)
        
     
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        view.addSubview(spinner)
        view.addSubview(searchView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.addSubview(spinner)
        
        navigationController?.isNavigationBarHidden = true
        
        
        
        // Fetching Data using APIManager
        spinner.startAnimating()
        fetchingData()
        
        
        
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        searchView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: 50)
        tableView.frame = CGRect(x: 0, y: searchView.bottom, width: view.width, height: (view.height - searchView.height  ) - 175)
        spinner.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        spinner.center = tableView.center
        
        
        
        
        
//        
        playerView.frame = CGRect(x: 0, y: tableView.bottom, width: view.width, height: 50)
        
    }
    
    
    
    
    var localImage = [UIImage]()
    // MARK: Fetching Image
    var id : String?
    
    private func fetchingImage(with string : String) {
        
        id = UUID().uuidString
        print("Fetching Image")
        
        
        
     
        
        let urlString = "http://collections.codecture.co/assets/upload_images/"
        let newString = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let newURLString = urlString + newString!
//        print(newURLString)
//
//
//        print(newURLString)
        
        if !newURLString.isEmpty{
            checkBookFileExists(withLink: newURLString){ [weak self] downloadedURL in
                guard let self = self else{
                    return
                }
                //
                DispatchQueue.main.async {
                    
                    //                    self.tableView.reloadData()
                }
            }
            
            
        }
    }
    
    public func fetchingData(){
        
        // MARK: API Calls
        
        print("Getting Response from APIManager")
        
        APIManager.shared.getSongs { result in
            
            switch result {
            
            case .success(let data):
                
                self.myViewModels = data.songs

                DispatchQueue.main.async {
                    self.setUpTableView()
                    self.spinner.stopAnimating()
                    
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.loadData()
                    self.spinner.stopAnimating()
                }
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
        
        let songsDatabase  = RealmSongs()
        
        songsDatabase.songsDatabase.append(objectsIn: viewModels )
        
        //TODO:  if songs.id == myviewmodels.id .. stop uploading to ream
        // MARK: Adding Data into Realm Database
        
        try! realm.write({
            
            realm.add(songsDatabase,update: .modified)
            
            print("Done Adding")
            
        })
        
        loadData()
    }
    
    
    private func loadData(){
        
        let data = self.realm.objects(SongsDatabase.self)

        
        print("Data Count = \(data.count)")
        
        
        realmDataArray = data
        
        print("My Array Count = \(realmDataArray?.count ?? 0)")
        
        guard let array = realmDataArray else{
            return
        }
        
        for x in 0...array.count - 1 {
                        
            fetchingImage(with: (array[x].song_image!))
            
        }
        
        
        tableView.reloadData()
        
    }
    
    // For downloading image
    func checkBookFileExists(withLink link: String, completion: @escaping ((_ filePath: URL)->Void)){
        let urlString = link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        if let url  = URL.init(string: urlString ?? ""){
            let fileManager = FileManager.default
            if let documentDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create: false){
                
                let filePath = documentDirectory.appendingPathComponent(url.lastPathComponent, isDirectory: false)
                
                do {
                    if try filePath.checkResourceIsReachable() {
                        print("file exist")
                        completion(filePath)
                        
//                        print("File Path ?=  \(filePath)")
                        
                    } else {
                        print("file doesnt exist")
                        downloadFile(withUrl: URL(string: link)!, andFilePath: filePath, completion: completion)
                    }
                } catch {
                    print("file doesnt exist")
                    downloadFile(withUrl:URL(string: link)! , andFilePath: filePath, completion: completion)
                }
            }else{
                print("file doesnt exist")
            }
        }else{
            print("file doesnt exist")
        }
    }
    
    
    func downloadFile(withUrl url: URL, andFilePath filePath: URL, completion: @escaping ((_ filePath: URL)->Void)){
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data.init(contentsOf: url)
                try data.write(to: filePath, options: .atomic)
                print("saved at \(filePath.absoluteString)")
                DispatchQueue.main.async {
                    completion(filePath)
                }
            } catch {
                print("an error happened while downloading or saving the file")
            }
        }
    }
    
    
    
    
    
    
    
    
    //
    private func passData(_ data:SongsDatabase) {
        var newdata : SongsDatabase?
        
        self.playerView.isHidden = false
        newdata = data
        
        DispatchQueue.main.async {
            self.playerView.title.text = newdata?.song_title
            self.playerView.subTitle.text = newdata?.song_description
            self.playerView.soundImageView.image = self.getSavedImage(named: (newdata?.song_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
        }
        
        
        
    }
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            
            print("URL ==\(URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)")
            
            
            
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    
    
}

extension SoundViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return realmDataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as? SoundsTableViewCell else {
            fatalError()
        }
        
        
        cell.configure(viewModels: realmDataArray![indexPath.row])
        cell.playButton.tag = indexPath.row
        cell.delegate = self
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        playerView.isHidden = false
        
        let data = realmDataArray?[indexPath.row]
        print("Current Data")
//        passData(data!)
        
//        if self.audioPlayer.isPlaying{
//            self.audioPlayer.stop()
//        }
        
        let vc = PlayerViewController()
        vc.newData = data
        vc.newImage = tableView.cellForRow(at: indexPath)?.imageView?.image
        navigationController?.pushViewController(vc, animated: true)

        
    }
    
}







extension SoundViewController:  SoundsTableViewCellDelegate{
    
    func didTapPlayButton(button: UIButton) {
        print(button.tag)
        
        let data = realmDataArray![button.tag]
        print(data)
        
        self.passData(data)
        let urlstring = "http://collections.codecture.co/assets/upload_files/\(data.song_file!.trimmingCharacters(in: .whitespaces))"
        
        
        
        print(urlstring)
        
        
        if !urlstring.isEmpty{
            
            APIManager.shared.checkBookFileExists(withLink: urlstring){ [weak self] downloadedURL in
                guard let self = self else{
                    return
                }
                self.play(url: downloadedURL)
            }
            
            
        }
        
        
        
        
        
        
    }
    func play(url: URL) {
        print("playing \(url)")
        
        do {
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            //            audioPlayer?.delegate = self
            audioPlayer?.play()
            let _ = (audioPlayer?.currentTime ?? 0)/(audioPlayer?.duration ?? 0)
            DispatchQueue.main.async {
                // do what ever you want with that "percentage"
            }
            
        } catch let error {
            print("Error \(error)")
            audioPlayer = nil
        }
        
    }
    
}
extension SoundViewController: PlayerViewDelegate{
    func didTapStop() {
        
        guard let audioPlayer = audioPlayer else {
            return
        }
        
//
        if audioPlayer.isPlaying {
            audioPlayer.stop()
        }
        else {
            self.audioPlayer.play()        }
        print("Audio Stopped")
    }
    
    
}
