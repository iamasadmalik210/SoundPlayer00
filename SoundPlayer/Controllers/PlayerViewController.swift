//
//  PlayerViewController.swift
//  SoundPlayer
//
//  Created by Asad on 03/08/2021.
//

import UIKit
import MediaPlayer
import SDWebImage
import UIImageColors
import SDDownloadManager

protocol PlayerViewControllerDelegate  {
    func didTapPlayButton(selectedId: String)
}

class PlayerViewController: UIViewController {
    
    
  var delegate : PlayerViewControllerDelegate?
    var music : String?
    var state : Bool?
    
    var isPlaying: Bool?
    var newData : SongsDatabase?
    var newImage : UIImage?
    
    var audioPlayer : AVAudioPlayer!
    weak var timer : Timer?
    var playerItem : AVPlayerItem?
    let downloadManager = SDDownloadManager.shared
    
    var selectedId: String = ""
    
    let directoryName : String = "TestDirectory"
    
//    var completionHandler : (String) -> ()
    
    
    private let timerLabel : UILabel = {
        let label = UILabel()
        
        
        return label
        
        
    }()
    
    private let songImageView : UIImageView = {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        
        return imageView
        
        
    }()
    
    private let songTitle: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20,weight:.bold)
        label.textColor = .red
        //        label.backgroundColor  = .red
        label.textAlignment  = .center
        
        return label
        
        
    }()
    
    private let soundSubtitle: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        //        label.backgroundColor  = .red
        label.textAlignment  = .center
        
        return label
        
        
    }()
    
    private let playButton : UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "play.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        //        button.backgroundColor = .red
        button.titleLabel?.font = .systemFont(ofSize: 20)
        return button
        
        
    }()
    
    
    let spinner : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        
        
        return indicator
        
        
    }()
    
    let downloadingLabel : UILabel = {
        
        let label = UILabel()
        label.text = "Downloading"
        label.textAlignment = .center
        
        
        return label
    }()
    
    var myURL:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(timerLabel)
        view.addSubview(songTitle)
        view.addSubview(songImageView)
        view.addSubview(soundSubtitle)
        view.addSubview(playButton)
        
//        view.addSubview(downloadingLabel)
        
        
        view.addSubview(spinner)
        self.isPlaying = self.state
        configuringUI()
        
        // BY using UIImageColors Pods
        
        let colors = songImageView.image?.getColors()
        view.backgroundColor = colors?.background
        songTitle.textColor = colors?.primary
        soundSubtitle.textColor = colors?.secondary
        
        playButton.tintColor = colors?.detail
        
        print("Selected Id \(selectedId)")
       if  self.selectedId == newData?.id{
        print("\(selectedId) == \(newData?.id)")
        
        didTapPlay()
            
        }
       else {
        print("Not Playing")
       }
        

        print(newData)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        if audioPlayer != nil {
//            if audioPlayer.isPlaying{
//                audioPlayer.stop()
//            }
//            playButton.setImage(UIImage(systemName: "play.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)), for: .normal)
//
//
//        }
    }
//    public func passData(completion: ((String) -> Void)){
//
//        completion(selectedId)
//
//    }
    
    private func configuringUI(){
        
//        let timerValue = UserDefaults.standard.value(forKey: "timer_value")
//        timerLabel.text = timerValue as? String
        
        songTitle.text = newData?.song_title
        soundSubtitle.text  = newData?.song_description
        
        guard let selectedImage = newData?.song_image else {
            print("Image Error")
            return
        }
        
        songImageView.image = APIManager.shared.getSavedImage(named: selectedImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        
        
        music = newData?.song_file
        
        playButton.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        timerLabel.frame = CGRect(x: 40, y: view.safeAreaInsets.top+20, width: view.width-80, height: 40)
        
        songImageView.frame = CGRect(x: 100, y: view.safeAreaInsets.top + 100, width: view.width-200, height: 200)
        
        songImageView.layer.cornerRadius = songImageView.width/2
        
        songTitle.frame = CGRect(x: 20, y: songImageView.bottom+20, width: view.width - 40, height: 30)
        
        soundSubtitle.frame = CGRect(x: 30, y: songTitle.bottom, width: view.width - 60, height: 30)
        
        playButton.frame = CGRect(x: 30, y: soundSubtitle.bottom+10, width: view.width - 60, height: 50)
        
        spinner.center = view.center
        
        downloadingLabel.frame = CGRect(x: 40, y: view.height - ((tabBarController?.tabBar.height)! + 50), width: view.width - 80, height: 30)
        
        
    }
    
    var completionHandler: ((String) -> Void)?

   
    

    
 
    @objc func didTapPlay(){
        
        guard let musicName = newData?.song_file?.trimmingCharacters(in: .whitespaces) else {
            print("song Name Error ")
            return
        }


        let urlstring = "http://collections.codecture.co/assets/upload_files/\(musicName)"

        if audioPlayer != nil {
            if audioPlayer.isPlaying {
                playButton.setImage(UIImage(systemName: "play.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)), for: .normal)
                print("NotPlaying")

                delegate?.didTapPlayButton(selectedId: "")
                audioPlayer.stop()
            }

            else {
                print("isplaying")

                checkAndPlay(urlstring: urlstring)
                delegate?.didTapPlayButton(selectedId: selectedId)

            }


        }
        else {

            print("Selecred ID = \(selectedId)")
            spinner.startAnimating()
            checkAndPlay(urlstring: urlstring)
            print("isplaying")

            delegate?.didTapPlayButton(selectedId: (newData?.id)!)

        }

    }
    
    
    
    private func checkAndPlay(urlstring:String){
        if !urlstring.isEmpty{
            
            
            APIManager.shared.checkBookFileExists(withLink: urlstring){ [weak self] downloadedURL in
                guard let self = self else{
                    return
                }
                self.play(url: downloadedURL)
                DispatchQueue.main.async {
                    self.playButton.setImage(UIImage(systemName: "pause.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)), for: .normal)
                }
                
                self.spinner.stopAnimating()
                self.downloadingLabel.isHidden = true
                
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
            audioPlayer.volume = 0.5
            let _ = (audioPlayer?.currentTime ?? 0)/(audioPlayer?.duration ?? 0)
            DispatchQueue.main.async {
                // do what ever you want with that "percentage"
                
                self.playButton.setImage(UIImage(systemName: "pause.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)), for: .normal)
                
            }
            
        } catch let error {
            print("Error = \(error)")
            audioPlayer = nil
        }
        
    }
    
    
}







