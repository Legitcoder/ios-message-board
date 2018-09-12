//
//  MessageThreadController.swift
//  Message Board
//
//  Created by Moin Uddin on 9/12/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import Foundation

class MessageThreadController {
    
    func createMessageThread(title: String, completion: @escaping (Error?) -> Void) {
        
        //Create the new messageThread Object
        let messageThread = MessageThread(title: title)
        
        //Setup URL
        var requestURL = MessageThreadController.baseURL.appendingPathComponent(messageThread.identifier)
        requestURL.appendPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        //Encode JSON
        do {
            request.httpBody = try JSONEncoder().encode(messageThread)
        } catch {
            fatalError("Error encoding messageThread \(messageThread): \(error)")
        }
        
        //Make API REQUEST
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            //Typical Error checking logic
            if let error = error {
                NSLog("Error POSTing new device: \(error)")
                completion(error)
                return
            }
            guard let data = data else {
                NSLog("No data returned from data task: \(error!)")
                completion(NSError())
                return
            }
            //Important part: Append the new messageThead if successful
            self.messageThreads.append(messageThread)
            print("Post Successful")
            completion(nil)
        }
        
    }
    
    
    static let baseURL = URL(string: "https://lambda-message-board.firebaseio.com/")!
    var messageThreads: [MessageThread] = []
}
