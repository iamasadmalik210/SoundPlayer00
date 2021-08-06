//
//  Options.swift
//  SoundPlayer
//
//  Created by Asad on 04/08/2021.
//

import Foundation


struct Section {
    
    let title : String
    let options: [Option]
    
    
}

struct Option{
    
    let title: String
    let handler:() -> Void
    
}
