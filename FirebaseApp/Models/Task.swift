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
    let title: String
    let completed: Bool = false
    
    init(uid: String, title: String) {
        self.uid = uid
        self.title = title
    }
    
    func toDictionary() -> [String: Any] {
        return ["uid": uid, "title": title, "completed": completed]
    }
}
