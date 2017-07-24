//
//  GroupService.swift
//  Group-Connect
//
//  Created by Howard Wang on 7/20/17.
//  Copyright © 2017 Howard Wang. All rights reserved.
//
import Foundation
import UIKit
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct GroupService {
    
    static func createGroup(completion: @escaping (String?) -> Void) {
        let ref = Database.database().reference().child(Constants.groups)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let groupDict = snapshot.value as? [String: Any?] else {
                return
            }
            print(groupDict)
            
            var groupCode: String?
            var valid = false
            while !valid {
                let random = randomString()
                if groupDict[random] == nil {
                    valid = true
                    groupCode = random
                }
            }
            
            let coordinateDict = [Constants.Location.latitude : User.defaultLocation.coordinate.latitude, Constants.Location.longitude : User.defaultLocation.coordinate.longitude]
            
            let groupData = ["\(groupCode!)/\(User.current.uid)" : coordinateDict]
            
            ref.updateChildValues(groupData) { (error, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                }
                completion(groupCode)
            }
        })
        
    }
    
    private static func randomString() -> String {
        var randomString = ""
        let letters: NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        for _ in 0 ..< 1 {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
}