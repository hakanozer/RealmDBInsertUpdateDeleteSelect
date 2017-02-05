//
//  kisi.swift
//  RealmUygulama
//
//  Created by Hakan on 2/2/17.
//  Copyright © 2017 Hakan. All rights reserved.
//

import Foundation
import RealmSwift

class person: Object {
    
    dynamic var id = ""
    dynamic var name = ""
    dynamic var surname = ""
    dynamic var imageID = ""
    
    
    override class func primaryKey() -> (String!) {
        return "id"
    }
    
  
}
