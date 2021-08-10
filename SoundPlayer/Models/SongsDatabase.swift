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

//    @objc dynamic var randomId:String = UUID().uuidString
    var songsDatabase = List<SongsDatabase>()
//    var id : String = ""
////    var song =
    @objc dynamic var personalID : String = UUID().uuidString
//    
//    

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
    
//    @objc dynamic var songImage : UIImage?
//    @objc dynamic var songAudio : AVAudioFile?

//    override static func primaryKey() -> String? {
//        return "id"
//    }

    
    
}

//class RealmData: Object {
//
//    var parentCategory = LinkingObjects(fromType : RealmSongs.self,property:"songsData" )
//}
