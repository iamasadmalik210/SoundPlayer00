////
////  RealmModels.swift
////  SoundPlayer
////
////  Created by Asad on 06/08/2021.
////
//
//import Foundation
//import Realm
//import RealmSwift
//
//@objcMembers class SongModel: Object, Decodable {
//    let songs = RealmSwift.List<MySongs>()
//    
//    enum CodingKeys: String, CodingKey {
//      
//        case songs
//    }
//    
//    required init(from decoder: Decoder) throws
//    {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//       
//        
//        let songList = try container.decode([MySongs].self, forKey: .songs)
//        songs.append(objectsIn: songList)
//        
//        super.init()
//    }
//    
//    override static func primaryKey() -> String?
//    {
//        return "id"
//    }
//    
//    required override init()
//    {
//        super.init()
//    }
//    
//    required init(value: Any, schema: RLMSchema)
//    {
//        super.init(value: value, schema: schema)
//    }
//    
//    required init(realm: RLMRealm, schema: RLMObjectSchema)
//    {
//        super.init(realm: realm, schema: schema)
//    }
//}
//
//@objcMembers class MySongs: Object, Decodable {
//    
//    
//    /*
//     struct Songs:Decodable {
//         let id : String
//         let song_title: String
//         let song_description : String
//         let song_image: String
//         let song_file:String
//     }
//     */
//    dynamic var id: String = ""
//    dynamic var song_title: String = ""
//    dynamic var song_description: String = ""
//    dynamic var song_Image: String = ""
//    dynamic var song_file: String = ""
//
//    
////    let tracks = RealmSwift.List<StoredTrack>()
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case title
//        case description
//        case image
//        case songfile
//    }
//    
//    required init(from decoder: Decoder) throws
//    {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        id = try container.decode(String.self, forKey: .id)
//        song_title = try container.decode(String.self, forKey: .title)
//        song_description = try container.decode(String.self, forKey: .description)
//        song_file = try container.decode(String.self, forKey: .image)
//        
//        let trackList = try container.decode([StoredTrack].self, forKey: .tracks)
//        tracks.append(objectsIn: trackList)
//        
//        super.init()
//    }
//    
//    override static func primaryKey() -> String?
//    {
//        return "id"
//    }
//    
//    required override init()
//    {
//        super.init()
//    }
//    
//    required init(value: Any, schema: RLMSchema)
//    {
//        super.init(value: value, schema: schema)
//    }
//    
//    required init(realm: RLMRealm, schema: RLMObjectSchema)
//    {
//        super.init(value: realm)
//    }
//}
//
//
//}
//
