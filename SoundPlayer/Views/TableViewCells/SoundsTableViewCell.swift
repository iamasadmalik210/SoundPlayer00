//
//  SoundsTableViewCell.swift
//  SoundPlayer
//
//  Created by Asad on 03/08/2021.
//

import UIKit
import SDWebImage
import RealmSwift


protocol SoundsTableViewCellDelegate : AnyObject {
    
    func didTapPlayButton(button:UIButton)
}

struct BoolModels {
    var value = false
}


class SoundsTableViewCell: UITableViewCell {
        
    
    weak var delegate : SoundsTableViewCellDelegate?
    var isPlaying : Bool?
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
        label.textColor = .label
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
    
    public let playButton : UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        
        
        
        return button
        
        
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(soundTitle)
        addSubview(soundImageView)
        addSubview(soundSubtitle)
        contentView.addSubview(playButton)
        
        
        playButton.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
        
        isPlaying = false
    }
    @objc func didTapPlay(){
        
        isPlaying = true
        delegate?.didTapPlayButton(button: playButton)
        
    
        
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
    
    
    
    public func configure(viewModels:SongsDatabase){
        

        
        self.soundTitle.text = viewModels.song_title
        self.soundSubtitle.text = viewModels.song_description
        DispatchQueue.main.async {
            self.soundImageView.image = APIManager.shared.getSavedImage(named: (viewModels.song_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!)

           
            
     
        }}
    
    public func configureBoolValues(viewModels : BoolModels){
        
        self.isPlaying = viewModels.value
        
        
        
       

    }
    
}
