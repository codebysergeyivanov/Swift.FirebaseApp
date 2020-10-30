//
//  Task.swift
//  FirebaseApp
//
//  Created by Сергей Иванов on 29.10.2020.
//

import Foundation
import Firebase

struct Task {
    let uid: String
    let uuid: String
    let title: String
    var completed: Bool = false
    
    init(uid: String, uuid: String, title: String) {
        self.uid = uid
        self.uuid = uuid
        self.title = title
    }
    
    init(snapshot: DataSnapshot) {
        let dict = snapshot.value as! [String : AnyObject]
        self.uid = dict["uid"] as! String
        self.title = dict["title"] as! String
        self.completed = dict["completed"] as! Bool
        self.uuid = dict["uuid"] as! String
    }
    
    func toDictionary() -> [String: Any] {
        return ["uid": uid, "uuid": uuid, "title": title, "completed": completed]
    }
}
