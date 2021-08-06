//
//  SongsDatabase.swift
//  SoundPlayer
//
//  Created by Asad on 05/08/2021.
//

import Foundation
import RealmSwift
import AVFoundation


//class RealmSongs : Object {
//
//    var songsDatabase = List<SongsDatabase>()
//
//    override static func primaryKey() -> String? {
//        return "id"
//    }


class SongsDatabase : Object {
    
    @objc dynamic var id : String = ""
    
    @objc dynamic var song_title : String = ""

    @objc dynamic var song_description : String = ""
    @objc dynamic var song_image : String = ""

    @objc dynamic var song_file : String = ""
    
//    @objc dynamic var songImage : UIImage?
//    @objc dynamic var songAudio : AVAudioFile?

    override static func primaryKey() -> String? {
        return "id"
    }

    
    
}
