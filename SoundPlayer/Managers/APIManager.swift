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
                
//                let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                
                
//                let response = try JSONDecoder().decode(APIResponse.self, from: data)
//
//                guard let dodgeCoinData = response.data.values.first else {
//                    return
//                }
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
        guard let url = URL(string: Constants.resourceURL + "\(type)") else {
                return
            }
        print(url)

            URLSession.shared.dataTask(with: url) { (data,_,_) in
                guard let data = data else {
                    return
                }
                guard let image = UIImage(data: data) else {
                    return
                }
                print(data)
                do {
                
                   
                    completion(.success(image))
                }
                catch {
                    completion(.failure(error))
                }

            }  .resume()
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
                
                var songsDatabase = SongsDatabase()
                               
                
                completion(.success(result))
            }
            catch{
                completion(.failure(error))
            }
        }
        task.resume()
            
        }
    
    }
    
    

