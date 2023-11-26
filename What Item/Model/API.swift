//
//  NetworkingBrain.swift
//  What Item
//
//  Created by Misha Dovhiy on 16.02.2020.
//  Copyright © 2020 Misha Dovhiy. All rights reserved.
//

import UIKit
import SwiftyJSON

struct API {
    static func fetch(word:String, completion:@escaping(_ json:String?)->()) {
        NetworkingManager().fetchURL(usersObject: word, completion: completion)
    }
}

struct NetworkingManager {
    
    let url = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext"
    
    func fetchURL(usersObject: String, completion:@escaping(_ json:String?)->()) {
        
        let stringURL = "\(url)=&titles=\(usersObject)&indexpageids&redirects=1"
        perfomRequest(stringURL: stringURL, str: usersObject, completion: completion)
        
    }
    
    func perfomRequest(stringURL: String, str:String, completion:@escaping(_ json:String?)->()) {
        
        if let url = URL(string: stringURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: 
                                            {data,response,error in
                completion(handleTask(data:data, response:response,error:error, str: str))
            })
            task.resume()
        } else {
            print("error creating a url")
            completion(nil)
        }
        
    }
    
    func handleTask(data: Data?, response: URLResponse?, error: Error?, str:String) -> String? {

        if let safeData = data, error == nil {
            return convertJSON(safeData, str: str)
        } else {
            print("error handeling Task", error?.localizedDescription ?? "-")
            return nil
        }
        
    }

    func convertJSON(_ safeData: Data, str:String) -> String? {
        
        do {
            let json = try JSON(data: safeData)
            let pageID = json["query"]["pageids"][0]
            return json["query"]["pages"]["\(pageID)"]["extract"].string ?? "Sorry I can't find anything about '\(str)' on Wikipedia"
            
        } catch {
            print("error converint json", error)
            return nil
        }
        
    }
    
}
