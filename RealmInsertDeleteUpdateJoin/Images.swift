//
//  Images.swift
//  RealmInsertDeleteUpdateJoin
//
//  Created by Hakan on 2/3/17.
//  Copyright © 2017 Hakan. All rights reserved.
//

import Foundation
import RealmSwift

class Images: Object {
    
    dynamic var id = ""
    dynamic var imagePath = ""
    
    override class func primaryKey() -> (String!) {
        return "id"
    }
    
    
}



