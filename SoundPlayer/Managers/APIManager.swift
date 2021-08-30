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
    public func checkBookFileExists(withLink link: String, completion: @escaping ((_ filePath: URL)->Void)){
        let urlString = link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let url  = URL.init(string: urlString ?? ""){
            let fileManager = FileManager.default
            if let documentDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create: false){

                let filePath = documentDirectory.appendingPathComponent(url.lastPathComponent, isDirectory: false)

                do {
                    if try filePath.checkResourceIsReachable() {
                        print("file exist")
                        completion(filePath)

                    } else {
                        print("file doesnt exist")
                        print("Downloading Under Process")
                        downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
                        
                    }
                } catch {
                    print("file doesnt exist")
                    downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
                }
            }else{
                 print("file doesnt exist")
            }
        }else{
                print("file doesnt exist")
        }
    }
        

    func downloadFile(withUrl url: URL, andFilePath filePath: URL, completion: @escaping ((_ filePath: URL)->Void)) {
        
        
        
        
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data.init(contentsOf: url)
                try data.write(to: filePath, options: .atomic)
                print("saved at \(filePath.absoluteString)")
                DispatchQueue.main.async {
                    
                    completion(filePath)
                }

            } catch {
                print("an error happened while downloading or saving the file")
                completion(filePath)
            }
        }
        
    }
        
    
     public func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            
//            print("URL ==\(URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)")
            
            
            
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
}

    }
    
    

