//
//  SongsModel.swift
//  SoundPlayer
//
//  Created by Asad on 05/08/2021.
//

import Foundation

struct SongsModel:Decodable{
    
    let songs: [Songs]
    
}
struct Songs:Decodable {
    let id : String
    let song_title: String
    let song_description : String
    let song_image: String
    let song_file:String
}
