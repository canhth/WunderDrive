//
//  Suggestion.swift
//  CanhTran
//
//  Created by Tran Hoang Canh on 7/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import Foundation
import RealmSwift

// Use Codeable in case when we need to get suggestion from API
final class Suggestion: BaseRealmObjectModel, Codable {
    
    @objc dynamic var id            : Int = 0
    @objc dynamic var name          : String = "0"
    @objc dynamic var totalResult   : String = "0"
    @objc dynamic var created_at    : Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    /*  1. Fetch all Suggestion records
        2. Find the duplicated objects with 'name'
        3. If objects.count > 10 and no duplicated --> Delete the last one
        4. If duplicated then update id of the object
        5. Set new date for an object.
     */
    func saveLatestSuggestion() {
        let realm = try! Realm()
        let objects = realm.objects(Suggestion.self)
        
        let duplicatedObjects = objects.filter{ $0.name == self.name }
        
        if objects.count >= 10 && duplicatedObjects.count == 0 {
            objects.last?.delete()
        } else if duplicatedObjects.count > 0, let object = duplicatedObjects.first {
            self.id = object.id
        }
        
        let object = self.clone()
        object.created_at = Date()
        object.saveToLocal()
    }
    
    
    /// Get list suggestion for Realm data
    ///
    /// - Returns: array of Suggestions
    class func getListSuggestions() -> [Suggestion] {
        let realm = try! Realm()
        let objects = realm.objects(Suggestion.self).sorted(byKeyPath: "created_at", ascending: false)
        return objects.toArray()
    }
    
    
    /// Create a new Suggestion object
    ///
    /// - Parameters:
    ///   - name: query name
    ///   - totalResult: total results found
    /// - Returns: return the suggestion object
    static func createSuggestionObject(name: String, totalResult: String) -> Suggestion {
        let realm = try! Realm()
        let suggestion = Suggestion()
        suggestion.id = (realm.objects(Suggestion.self).max(ofProperty: "id") ?? 0) + 1
        suggestion.name = name
        suggestion.totalResult = totalResult
        suggestion.created_at = Date()
        
        return suggestion
    }
}

