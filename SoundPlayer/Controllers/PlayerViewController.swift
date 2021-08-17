//
//  PlayerViewController.swift
//  SoundPlayer
//
//  Created by Asad on 03/08/2021.
//

import UIKit
import MediaPlayer
import SDWebImage

class PlayerViewController: UIViewController {
    
    var music : String?
    
    
    var newData : SongsDatabase?
    var newImage : UIImage?
    
    var audioPlayer : AVAudioPlayer!
    weak var timer : Timer?
    var playerItem : AVPlayerItem?
    
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
        label.textColor = .white
//        label.backgroundColor  = .red
        label.textAlignment  = .center

        return label
        
        
    }()
    
    private let playButton : UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "play")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFill
//        button.backgroundColor = .red
        button.titleLabel?.font = .systemFont(ofSize: 20)
        return button
        
        
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
        
        
        
        
        configuringUI()
        
        
    }
    private func configuringUI(){
        let timerValue = UserDefaults.standard.value(forKey: "timer_value")
        
        timerLabel.text = timerValue as? String
        
        view.backgroundColor = .darkGray
//        print(newData)
        
      
        songTitle.text = newData?.song_title
        soundSubtitle.text  = newData?.song_description
        
        guard let selectedImage = newData?.song_image else {
            print("Image Error")
            return
        }
        
        // getting image from the url
        
//        songImageView.sd_setImage(with: URL(string: "http://collections.codecture.co/assets/upload_images/\(selectedImage)"), completed: nil)
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

    
    }
    
//    func getSavedImage(named: String) -> UIImage? {
//        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
//
////            print("URL ==\(URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)")
//
//
//
//            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
//        }
//        return nil
//}
    @objc func didTapPlay(){
        
        guard let musicName = newData?.song_file?.trimmingCharacters(in: .whitespaces) else {
            print("song Name Error ")
            return
        }
//                let newurl = type.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        
        print(musicName)
        
        let urlstring = "http://collections.codecture.co/assets/upload_files/\(musicName)"
        
        
        
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
 
       
    // Checking for download
    
    
        
        
        
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
            print("Error = \(error)")
            audioPlayer = nil
        }

    }
    
    
}
    
    
    
    
    
    
   
