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
    
    var isPlayingArray : [BoolModels]?
    
    var newSongsModels : [NewSoundData]?
    
    var realmDataArray : Results<SongsDatabase>?
    
    var audioPlayer : AVAudioPlayer!
    
    var searchView = SearchView()
    
    var searchArrRes : Results<SongsDatabase>?
    
    var realm = try! Realm()
    
    var isPlayingModel = [Bool]()
    
    var playerViewController = PlayerViewController()
    
    var selectedId = ""
    
    var searching : Bool!
    
    
    
    
    
    var colors = [UIColor.systemRed, UIColor.systemBlue, UIColor.systemOrange,
                  UIColor.systemPurple,UIColor.systemGreen]
    var tableViewHeaderText = ""
    
    /// an enum of type TableAnimation - determines the animation to be applied to the tableViewCells
    var currentTableAnimation: TableAnimation = .fadeIn(duration: 0.85, delay: 0.03) {
        didSet {
            //            self.tableViewHeaderText = currentTableAnimation.getTitle()
        }
    }
    var animationDuration: TimeInterval = 0.85
    var delay: TimeInterval = 0.05
    var fontSize: CGFloat = 26
    
    
    
    
    // MARK: UI's
    
    private let tableView : UITableView = {
        
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.register(SoundsTableViewCell.self, forCellReuseIdentifier: "cell")
        
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
        
        view.backgroundColor = .systemBackground
        
        searching = false
        playerView.isHidden = true
        playerView.delegate = self
        
        spinner.transform = CGAffineTransform.init(scaleX: 2, y: 2)
        
        
        // Spinner to start animating until data get fetched
        spinner.startAnimating()
        
        // Do any additional setup after loading the view.
        
        
        // Adding Subviews
        
        view.addSubview(searchView)
        view.addSubview(tableView)
        view.addSubview(playerView)
        view.addSubview(spinner)
        
        // Assigning Delegates
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchView.searchTextField.delegate = self
        
        navigationController?.isNavigationBarHidden = true
        
        
        // Calling Methods
        fetchingData()
        setupRefreshControl()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isHidden = true
        
        // set the separatorStyle to none and set the Title for the tableView
        self.tableView.separatorStyle = .none
        //        self.tableViewHeaderText = self.currentTableAnimation.getTitle()
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() ) {
            self.tableView.isHidden = false
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapPlayerView))
        playerView.addGestureRecognizer(tap)
        
        
        
        
    }
    
    @objc
    func didTapPlayerView(){
        print("Did Tap Player View ")
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        //
        //        if audioPlayer != nil{
        //            if audioPlayer.isPlaying {
        //                audioPlayer.stop()
        //            }
        //        }
    }
    
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: 50)
        
        spinner.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        spinner.center = tableView.center
        
        playerView.frame = CGRect(x: 0, y: view.height - (tabBarController!.tabBar.height + 50), width: view.width, height: 50)
        
        tableView.frame = CGRect(x: 0, y: searchView.bottom, width: view.width, height: view.height - tabBarController!.tabBar.height)
        
        
        
    }
    
    
    // MARK: Implementing Pull down to refresh
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
    }
    
    @objc
    private func refreshTableView(sender: UIRefreshControl) {
        print("refreshing...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            //
            
            
            
            sender.endRefreshing()
        })
        
    }
    
    
    
    
    //    var localImage = [UIImage]()
    
    // MARK: Fetching Image
    
    //    var id : String?
    
    private func fetchingImage(with string : String) {
        
        //        id = UUID().uuidString
        print("Fetching Image")
        
        let urlString = "http://collections.codecture.co/assets/upload_images/"
        let newString = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let newURLString = urlString + newString!
        
        if !newURLString.isEmpty{
            checkBookFileExists(withLink: newURLString){ [weak self] downloadedURL in
                guard let self = self else{
                    return
                }
                
                // Reloading Data
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    
                    self.tableView.reloadData()
                })
                
                
            }
            
            
        }
    }
    
    
    
    
    // MARK: - Fetching Sounds
    
    private func fetchingSounds(with string : String) {
        
        
        print("Fetching Sounds")
        
        let newString = string.trimmingCharacters(in: .whitespaces)
        
        //        let newURLString =
        let newURLString = "http://collections.codecture.co/assets/upload_files/\(newString)"
        
        //
        
        
        self.spinner.startAnimating()
        
        if !newURLString.isEmpty{
            
            print("Start")
            APIManager.shared.checkBookFileExists(withLink: newURLString){ [weak self] downloadedURL in
                guard let self = self else{
                    return
                    
                }
                self.spinner.stopAnimating()
                
                
            }
            
            // Reloading Data
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.tableView.reloadData()
            })
            self.spinner.stopAnimating()
            
        }
        
        print("Done")
        
    }
    
    
    // MARK: Fetching Data from the API into Realm Database
    
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
    
    
    // MARK: Fetching Data form the Realm Database into Array
    
    private func loadData(){
        
        let data = self.realm.objects(SongsDatabase.self)
        
        print("Data Count = \(data.count)")
        
        realmDataArray = data
        
        print("My Array Count = \(realmDataArray?.count ?? 0)")
        
        guard let array = realmDataArray else{
            return
        }
        
        for x in 0...array.count-1  {
            
            fetchingImage(with: (array[x].song_image!))
            fetchingSounds(with: (array[x].song_file!))
            
            
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
        
        newdata = data
        
        DispatchQueue.main.async {
            self.playerView.title.text = newdata?.song_title
            self.playerView.subTitle.text = newdata?.song_description
            self.playerView.soundImageView.image = APIManager.shared.getSavedImage(named: (newdata?.song_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)
        }
        
        
        
    }
    var search : String = ""
    var value = false
    
    
}

extension SoundViewController: UITableViewDelegate, UITableViewDataSource , UITextFieldDelegate {
    
    
    
    // MARK: UITextField Delegate Methods.
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        textField.resignFirstResponder()
        search = ""
        
        searching = false
        tableView.reloadData()
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searching = true
        
        if string.isEmpty
        {
            search = String(search.dropLast())
            searching = false
            
            tableView.reloadData()
        }
        else
        {
            search=textField.text!+string
        }
        
        print(search)
        
        let predicate=NSPredicate(format: "SELF.song_title CONTAINS[cd] %@", search)
        let newData = realm.objects(SongsDatabase.self).filter(predicate)
        
        print("newData  \(newData)")
        print(newData.count)
        
        
        self.searchArrRes = newData
        tableView.reloadData()
        
        
        return true
    }
    
    
    // TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching == true{
            
            return searchArrRes?.count ?? 0
            
        }
        else {
            
            return realmDataArray?.count ?? 0
            
        }
        
        
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as? SoundsTableViewCell else {
            fatalError()
        }
        
        if searching == true{
            cell.configure(viewModels: searchArrRes![indexPath.row])
            if selectedId == searchArrRes![indexPath.row].id {
                cell.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            } else {
                cell.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
            
        }
        else {
            cell.configure(viewModels: realmDataArray![indexPath.row])
            
            if selectedId == realmDataArray![indexPath.row].id {
                cell.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                
            } else {
                cell.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                
                
            }
        }
        
        
        
        
        cell.playButton.tag = indexPath.row
        
        
        
        cell.delegate = self
        
        
        
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fetch the animation from the TableAnimation enum and initialze the TableViewAnimator class
        //
        //        let animation = currentTableAnimation.getAnimation()
        //        let animator = TableViewAnimator(animation: animation)
        //        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //        playerView.isHidden = false
        
        var data : SongsDatabase?
        
        if searching == true {
            data = searchArrRes?[indexPath.row]
        }
        else {
            data = realmDataArray?[indexPath.row]
        }
        if audioPlayer != nil{
            if audioPlayer.isPlaying {
                value = true
            }
        }
        
        
        let vc = PlayerViewController()
        
        print(selectedId)
        
        vc.selectedId = selectedId
        
        vc.delegate = self
        
        vc.newData = data
        
        vc.newImage = tableView.cellForRow(at: indexPath)?.imageView?.image
        
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
}







extension SoundViewController:  SoundsTableViewCellDelegate{
    
    func didTapPlayButton(button: UIButton) {
        var data : SongsDatabase?
        
        print("Button Tag == \(button.tag) ")
        print("ID == \(selectedId)")
        
        
        
        
        // MARK: For Adjusting Playing Button
        let song = realmDataArray![button.tag]
        
        if searching == true{
            let song = searchArrRes![button.tag]
            if self.selectedId == song.id {
                self.selectedId = ""
            } else {
                self.selectedId = song.id!
            }
        }
        else {
            if self.selectedId == song.id {
                self.selectedId = ""
            } else {
                self.selectedId = song.id!
            }
            
            
            
        }
        self.tableView.reloadData()
        
        
        
        
        
        
        
        
        if searching == true {
            data = searchArrRes![button.tag]
            
        }
        else {
            data = realmDataArray![button.tag]
            
        }
        
        
        
        let urlstring = "http://collections.codecture.co/assets/upload_files/\(data!.song_file!.trimmingCharacters(in: .whitespaces))"
        
        
        if audioPlayer != nil {
            
            if audioPlayer.isPlaying{
                
                print("\(selectedId) == \(song.id)")
                if self.selectedId == "" {
                    self.audioPlayer.stop()
                    print("Audio Player Stopped")
                    self.playerView.isHidden = true
                } else {
                    
                    self.passData(data!)
                    playMusicWithString(urlstring: urlstring)
                    
                }
                
                
                
                //
            }
            else {
                
                self.passData(data!)
                playMusicWithString(urlstring: urlstring)
                
                
                print("Play The Music")
            }
        }
        else {
            self.passData(data!)
            
            
            playMusicWithString(urlstring: urlstring)
            
        }
        
    }
    
    
    
    
    private func playMusicWithString(urlstring:String){
        
        //
        
        
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
                UIView.animate(withDuration: 3.0, delay: 3.0, options: .curveEaseInOut) {
                    self.playerView.isHidden = false
                    
                }
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
            
            UIView.transition(with: playerView, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.playerView.isHidden = true
                              })
            
            
            audioPlayer.stop()
            selectedId = ""
            tableView.reloadData()
            
        }
        
        else
        {
            UIView.transition(with: playerView, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.playerView.isHidden = true
                              })
            //            self.audioPlayer.play()
            
        }
        print("Audio Stopped")
    }
    
    
}


extension SoundViewController: PlayerViewControllerDelegate{
    
    
    
    func didTapPlayButton(selectedId: String) {
        
        print("Current id \(self.selectedId)")
        
        print("passed ID id \(self.selectedId)")
        
        
        self.selectedId = selectedId
        if selectedId == "" {
            
            if audioPlayer != nil{
                audioPlayer.stop()
            }
            
            self.playerView.isHidden = true
            self.tableView.reloadData()
            print("Stop Music")
        }
        else {
            print("Play Music")
            
            if audioPlayer != nil {
                if !audioPlayer.isPlaying{
                    let  string = Int(selectedId)! - 1
                    loadAndPlay(string: string)
                }
                else {
                    let  string = Int(selectedId)! - 1
                    loadAndPlay(string: string)
                    
                }
                
            }
            else {
                let  string = Int(selectedId)! - 1
                loadAndPlay(string: string)
                
            }
            self.tableView.reloadData()
        }
        
        
        
        
        
    }
    
    private func loadAndPlay(string:Int){
        let song =  realmDataArray?[string].song_file!
        let data = realmDataArray?[string]
        print("song Name = \(song)")
        
        let urlstring = "http://collections.codecture.co/assets/upload_files/\(song!.trimmingCharacters(in: .whitespaces))"
        
        
        passData(data!)
        playMusicWithString(urlstring: urlstring)
        self.tableView.reloadData()
        
    }
}
