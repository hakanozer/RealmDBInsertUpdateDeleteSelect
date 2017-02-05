//
//  ViewController.swift
//  RealmInsertDeleteUpdateJoin
//
//  Created by Hakan on 2/3/17.
//  Copyright © 2017 Hakan. All rights reserved.
//

import UIKit
import RealmSwift
import SCLAlertView

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    
    var realm:Realm! = nil
    var data: Results<person>? = nil
    var imgData: Results<Images>? = nil
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtSurName: UITextField!
    @IBAction func btnAdd(_ sender: UIButton) {
        
        if imageID == "" {
            SCLAlertView().showWarning("Image Select", subTitle: "Please Icon Select")
        }else {
            let n = txtName.text
            let s = txtSurName.text
            let pr = person()
            
            pr.id = UUID.init().description
            pr.name = n!
            pr.surname = s!
            pr.imageID = imageID
            try! realm.write {
                realm.add(pr)
                dataGetir()
                imageID = ""
            }
        }
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
        })
        Realm.Configuration.defaultConfiguration = config
        do {
            self.realm = try Realm()
            dataGetir()
            imageDataGetir()
        } catch let error as NSError {
            print("error \(error) ")
        }
        
        let imageAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.imageAdd(sender:)))
        navigationItem.rightBarButtonItem = imageAdd
        
        // path
        print(realm.configuration.fileURL!)
        
    }
    
    func imageAdd(sender:UIBarButtonItem) {
        let alert = SCLAlertView()
        let txt = alert.addTextField("Image URL")
        alert.addButton("Download Image") {
            let img = Images()
            img.id = UUID.init().description
            let url = URL(string: txt.text!)!
            if let imgNSData = NSData(contentsOf: url) {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let writePath = documentsPath.appending("/\(img.id)")
                imgNSData.write(toFile: writePath, atomically: true)
                img.imagePath = img.id
                print("Gelen yol \(writePath)")
                let realm = try! Realm()
                try! realm.write {
                    realm.add(img)
                    self.imageDataGetir()
                }
                
            }
        }
        alert.showEdit("Image Add", subTitle: "Place Enter Image Path")
    }
    
    
    
    func dataGetir(){
        data = self.realm.objects(person.self)
        self.tableView.reloadData()
    }
    
    
    func imageDataGetir(){
        imgData = self.realm.objects(Images.self)
        self.imageCollection.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (data?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let ps = data?[indexPath.row]
        cell.textLabel?.text = ps?.name
        cell.detailTextLabel?.text = ps?.surname
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let imagePath = documentsPath.appending("/\((ps?.imageID)!)")
        print("image path : \(imagePath)")
        cell.imageView?.image = UIImage(contentsOfFile: imagePath)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let ps = self.data?[indexPath.row]
        let sil = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            let deletePs = self.realm.object(ofType: person.self, forPrimaryKey:(ps?.id)! )
            try! self.realm.write {
                self.tableView.beginUpdates()
                self.realm.delete(deletePs!)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.endUpdates()
            }
        }
        
        let duzenle = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.performSegue(withIdentifier: "detail", sender: (ps?.id)!)
        }
        
        duzenle.backgroundColor = UIColor.orange
        sil.backgroundColor = UIColor.red
        
        return [sil, duzenle]
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ps = self.data?[indexPath.row]
        performSegue(withIdentifier: "detail", sender: (ps?.id)!)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let vc = segue.destination as! detail
            vc.id = sender as! String
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (imgData?.count)!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colCell", for: indexPath) as! imageCell
        let sdata = imgData?[indexPath.row]
        print((sdata?.imagePath)!)
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let writePath = documentsPath.appending("/\((sdata?.imagePath)!)")
        print("Yol \(writePath)")
        cell.logo.image = UIImage(contentsOfFile: writePath)
        cell.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 6
        return cell
    }
    
    var imageID = ""
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor(red:0.76, green:0.76, blue:0.76, alpha:1.0)
        let sdata = imgData?[indexPath.row]
        print((sdata?.id)!)
        imageID = (sdata?.id)!
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
    }
    
}


