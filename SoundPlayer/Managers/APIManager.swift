//
//  APIManager.swift
//  SoundPlayer
//
//  Created by Asad on 05/08/2021.
//

import Foundation
import UIKit

import RealmSwift


class APIManager {
    
    static let shared = APIManager()
    
    private init () {}
    
    let realm = try! Realm()
    
    struct Constants  {
        
        static let baseAPIURL = "http://collections.codecture.co/collection.php"
        
        static let resourceURL = "http://collections.codecture.co/assets/upload_images/"
        
//        static let baseAPIURL = "https://pro-api.coinmarketcap.com/v1/"

    }
    
    
    enum APIError : Error {
        
        case failedToGetData
    }
    enum HTTPMethod: String {
        case GET
        case PUT
        case POST
        case DELETE
        
    }
    
    
    public func getSongDetails( completion: @escaping (Result<SongsModel, Error>) -> Void) {
        
        
        guard let url = URL(string: Constants.baseAPIURL) else {
            completion(.failure(APIError.failedToGetData))
            return
        }
        
        
        print(url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ data,_,error in
            
            if let error = error{
                completion(.failure(error))
            }
            guard let data = data else {
                return
                
                
            }
            
            do {
                let result = try JSONDecoder().decode(SongsModel.self, from: data)

                completion(.success(result))
            }
            catch{
                completion(.failure(error))
            }
        }
        task.resume()
            
        }
    
    
//
    
    
    
    
    
    
    public func loadImage(with type:String, completion:@escaping (Result<UIImage, Error>) -> Void) {
        
        print(type)
        
        let newurl = type.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
       
//        guard let url = URL(string: "https://static.dw.com/image/51029829_303.jpg") else {
//            print("url rrror")
//                return
//            }
        guard let url = URL(string: Constants.resourceURL + "\(type)") else {
            print("url rrror")
                return
            }
        
        print("the new url == \(Constants.resourceURL)\(newurl!)")

        
       let task = URLSession.shared.dataTask(with: url) { data, _, err in
            guard let imageData = data , err == nil  else { return}
            let image = UIImage(data: imageData)
        print(imageData)
        completion(.success(image!))
        }
        task.resume()
 
        }
    
    
    
    
    
    
    
    // MARK: Getting Song Details using REALM MODELS
    public func getSongs( completion: @escaping (Result<SongsModel, Error>) -> Void) {
        
        
        guard let url = URL(string: Constants.baseAPIURL) else {
            completion(.failure(APIError.failedToGetData))
            return
        }
        
        
        print(url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ data,_,error in
            
            if let error = error{
                completion(.failure(error))
            }
            guard let data = data else {
                return
                
                
            }
            
            do {
                let result = try JSONDecoder().decode(SongsModel.self, from: data)
                
                               
                
                completion(.success(result))
            }
            catch{
                completion(.failure(error))
            }
        }
        task.resume()
            
        }
    
    }
    
    

