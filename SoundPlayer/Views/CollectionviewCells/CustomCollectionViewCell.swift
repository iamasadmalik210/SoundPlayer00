//
//  CustomCollectionViewCell.swift
//  SoundPlayer
//
//  Created by Asad on 03/08/2021.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    private let weatherImage : UIImageView = {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView .layer.cornerRadius = 10
        imageView.tintColor = .white
        
//        imageView.backgroundColor = .green
        
        return imageView
        
        
    }()
    
    private let weatherTitle: UILabel = {
       let label = UILabel()
        
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
//        label.backgroundColor  = .red
        label.textAlignment  = .center

        return label
        
        
    }()
    private let playButton : UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "playpause"), for: .normal)
        
        button.tintColor = .white
        return button
        
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(weatherImage)
        addSubview(weatherTitle)
        addSubview(playButton)
        
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        weatherImage.frame = CGRect(x: 40, y: 10, width: width-80, height: height-100)
        weatherTitle.frame = CGRect(x: 20, y: weatherImage.bottom+10, width: width-40, height: 30)
        playButton.frame = CGRect(x: 20, y: weatherTitle.bottom+10, width: width-40, height: 30)
    }
    
    public func configure(viewModels : CustomModel ){
        weatherImage.image = viewModels.image
        weatherTitle.text = viewModels.title
    }
}
