//
//  Upload.swift
//  FinalProject
//
//  Created by Griffin Coates on 12/6/22.
//

import Foundation
import FirebaseFirestoreSwift
enum Condition: String, CaseIterable {
    case new
    case used
    case trashed
}

struct Upload: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var userID: String = ""
    var name = ""
    var isbn = ""
    var courseName = ""
    var price = ""
    var condition: String = Condition.used.rawValue
    var email = ""
    
    var dictionary: [String: Any] {
        return ["name": name, "userID": userID , "isbn": isbn, "courseName": courseName, "price": price, "condition": condition, "email": email]
    }
}
