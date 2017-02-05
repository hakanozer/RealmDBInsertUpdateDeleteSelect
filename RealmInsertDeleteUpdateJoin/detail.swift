//
//  detail.swift
//  RealmUygulama
//
//  Created by Hakan on 2/2/17.
//  Copyright © 2017 Hakan. All rights reserved.
//

import UIKit
import RealmSwift

class detail: UIViewController {
    
    var id = ""
    var realm:Realm! = nil
    var data: Results<person>? = nil
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtSurName: UITextField!
    
    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
        })
        Realm.Configuration.defaultConfiguration = config
        do {
            self.realm = try Realm()
        } catch let error as NSError {
            print("error \(error) ")
        }
        
        let ps = realm.object(ofType: person.self, forPrimaryKey: id)
        let pi = realm.object(ofType: Images.self, forPrimaryKey: ps?.imageID)
        txtName.text = ps?.name
        txtSurName.text = ps?.surname
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let imagePath = documentsPath.appending("/\((pi?.imagePath)!)")
        print("image path : \(imagePath)")
        img.image = UIImage(contentsOfFile: imagePath)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
