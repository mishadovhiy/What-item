//
//  NetworkingBrain.swift
//  What Item
//
//  Created by Misha Dovhiy on 16.02.2020.
//  Copyright © 2020 Misha Dovhiy. All rights reserved.
//

import UIKit
import SwiftyJSON

struct NetworkingManager {
    
    let url = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext"
    
    func fetchURL(usersObject: String) {
        
        let stringURL = "\(url)=&titles=\(usersObject)&indexpageids&redirects=1"
        perfomRequest(stringURL: stringURL)
        
    }
    
    func perfomRequest(stringURL: String) {
        
        if let url = URL(string: stringURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handleTask(data:response:error:))
            task.resume()
        } else { print("error creating a url") }
        
    }
    
    func handleTask(data: Data?, response: URLResponse?, error: Error?) {
        
        if error != nil {
            print("error handeling Task", error!)
            return
        }
        if let safeData = data {
            convertJSON(safeData)
        }
        
    }

    func convertJSON(_ safeData: Data) {
        
        do {
            let json = try JSON(data: safeData)
            let pageID = json["query"]["pageids"][0]
            V.textHolder = json["query"]["pages"]["\(pageID)"]["extract"].string ?? "Sorry I can't find anything about '\(V.userWord)' on Wikipedia"
            
        } catch { print("error converint json", error) }
        
    }
    
}
