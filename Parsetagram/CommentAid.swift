//
//  CommentAid.swift
//  Parsetagram
//
//  Created by Pedro Sandoval Segura on 6/23/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import Foundation

class CommentAid {
    
    static func getLatestComment(storage: [[String]]) -> (username: String, timestamp: String, comment: String) {
        
        let lastComment = storage[storage.count - 1] //The last post is the latest
        let username = lastComment[0]
        let timestamp = lastComment[1]
        let comment = lastComment[2]
        
        return (username, timestamp, comment)
    }
    
    static func unpackCommentArray(storage: [[String]]) -> (usernames: [String], timestamps: [String], comments: [String]) {
        var usernames = [String]()
        var timestamps = [String]()
        var comments = [String]()
        for commentStructure in storage {
            usernames.append(commentStructure[0])
            timestamps.append(commentStructure[1])
            comments.append(commentStructure[2])
        }
        
        return (usernames, timestamps, comments)
    }
    
    static func repackCommentArray(usernames: [String], timestamps: [String], comments: [String]) -> [[String]] {
        var storage = [[String]]()
        for index in 0 ..< usernames.count {
            storage.append( [usernames[index], timestamps[index], comments[index]] )
        }
        return storage
    }
    
}