//
//  SearchView.swift
//  SoundPlayer
//
//  Created by Asad on 04/08/2021.
//

import UIKit

class SearchView: UIView {
    
    private let searchTextField: UITextField = {
       let textField = UITextField()
        
        textField.placeholder = "Search"
        textField.insetsLayoutMarginsFromSafeArea = true
        
        
        
        
     

        return textField
        
        
    }()
    private let underlineView : UIView = {
       let view = UIView()
        view.backgroundColor = .darkGray
        return view
        
        
    }()

    override init(frame:CGRect) {
        super.init(frame: frame)
        addSubview(searchTextField)
        addSubview(underlineView)
        
        clipsToBounds = true
    
        
        backgroundColor = .systemBackground
        
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = .always
        
        
        searchTextField.frame = CGRect(x: 20, y: 5, width: width - 40, height: height - 10)
        underlineView.frame = CGRect(x: 25, y: searchTextField.frame.height - 5, width: width-50, height: 1)
        

        
    }
    
}
