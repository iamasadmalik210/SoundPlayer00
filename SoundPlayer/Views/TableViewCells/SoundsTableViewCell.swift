//
//  SoundsTableViewCell.swift
//  SoundPlayer
//
//  Created by Asad on 03/08/2021.
//

import UIKit
import SDWebImage
import RealmSwift


class SoundsTableViewCell: UITableViewCell {
    
//    var realm = try! Re
    
    
    public let soundImageView : UIImageView = {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView .layer.cornerRadius = 10
        
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .darkGray
        
        
        
        return imageView
        
        
    }()
    
    private let soundTitle: UILabel = {
       let label = UILabel()
        
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
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
        
        button.setImage(UIImage(systemName: "playpause"), for: .normal)
        
        
        
        return button
        
        
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(soundTitle)
        addSubview(soundImageView)
        addSubview(soundSubtitle)
        addSubview(playButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        soundImageView.frame = CGRect(x: 15, y: 20, width: width/2-30, height: height-40)
        
        soundTitle.frame = CGRect(x: soundImageView.right + 30, y: 30, width: width/2 - 30, height: 20)
        
        soundSubtitle.frame = CGRect(x: soundImageView.right + 30, y: soundTitle.bottom, width: width/2-30, height: 20)

        playButton.frame = CGRect(x: soundImageView.right + 20, y: soundSubtitle.bottom+20, width: width/2, height: 20)

        
        
        
    }
    var imageArray  = [UIImage]()
    
//    public func configure(viewModels:Songs){
//
//      //  soundImageView.sd_setImage(with: URL(string: "http://collections.codecture.co/assets/upload_images/\(viewModels.song_image)"), completed: nil)
//
//
//        soundTitle.text = viewModels.song_title
//        soundSubtitle.text = viewModels.song_description
//
//    }
    
    
    
    
    public func configure(viewModels:SongsDatabase){
        
      //  soundImageView.sd_setImage(with: URL(string: "http://collections.codecture.co/assets/upload_images/\(viewModels.song_image)"), completed: nil)
        
        
        soundTitle.text = viewModels.song_title
        soundSubtitle.text = viewModels.song_description

    }
    
    public func configureImage(viewModels:Image){
        
      //  soundImageView.sd_setImage(with: URL(string: "http://collections.codecture.co/assets/upload_images/\(viewModels.song_image)"), completed: nil)
        
        
        soundImageView.image = viewModels.image

    }
}
