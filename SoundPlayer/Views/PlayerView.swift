//
//  PlayerView.swift
//  SoundPlayer
//
//  Created by Asad on 11/08/2021.
//

import UIKit

protocol PlayerViewDelegate:AnyObject {
    func didTapStop()
}

class PlayerView: UIView {
    
    weak var delegate:PlayerViewDelegate?
    public var title: UILabel = {
       let label = UILabel()
        label.text = "Title"
        label.font = .systemFont(ofSize: 18,weight:.medium)
        label.textColor = .white

        return label
        
        
    }()
    
    
    public var subTitle: UILabel = {
       let label = UILabel()
        
        label.text = "Subtitle"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white

        return label
        
        
    }()
    
    public let stopButton : UIButton = {
       let button = UIButton()
        
        button.setImage(UIImage(systemName: "stop.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)), for: .normal)
        button.tintColor = .white
        
        return button
        
        
    }()
    
    public var soundImageView : UIImageView = {
        let imageView = UIImageView()
        
        
        imageView.image = UIImage(named: "image1")
        imageView.contentMode = .scaleAspectFill
        
        imageView.clipsToBounds = true
        
        return imageView
        
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .darkGray
        
        addSubview(title)
        addSubview(subTitle)
        addSubview(stopButton)
        addSubview(soundImageView)
        
        stopButton.addTarget(self, action: #selector(didTapStop), for: .touchUpInside)
    }
   
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapStop() {
        delegate?.didTapStop()
           
       }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        soundImageView.frame = CGRect(x: 0, y: 0, width: 50, height: height)
        
        title.frame = CGRect(x: soundImageView.right + 5, y: 5, width: width, height: 20)
        
        subTitle.frame = CGRect(x: soundImageView.right + 5, y: title.bottom, width: width, height: 20)

        stopButton.frame = CGRect(x: width-80, y: 10, width: 60, height: 30)
        
        
    }
    
}
