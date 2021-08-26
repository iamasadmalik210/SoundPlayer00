//
//  SongsDatabase.swift
//  SoundPlayer
//
//  Created by Asad on 05/08/2021.
//

import Foundation
import RealmSwift
import AVFoundation


class RealmSongs : Object {

    var songsDatabase = List<SongsDatabase>()
    @objc dynamic var personalID : Int = 0
    
    

    override static func primaryKey() -> String? {
        return "personalID"
    }
}

class SongsDatabase : Object,Decodable {
    
    @objc dynamic var id : String?
    
    @objc dynamic var song_title : String?

    @objc dynamic var song_description : String?
    @objc dynamic var song_image : String?

    @objc dynamic var song_file : String?
    
//    @objc dynamic var isPlaying : Bool = false

}
