//
//  FaceOff_ViewController.swift
//  Novesta
//
//  Created by Brian Lin on 9/24/17.
//  Copyright © 2017 Brian Lin. All rights reserved.
//

import UIKit
import Firebase

class faceOff_custom_cell: UITableViewCell {
    @IBOutlet weak var user1_logo: UIImageView!
    @IBOutlet weak var user1_label: UILabel!
    @IBOutlet weak var user2_label: UILabel!
    @IBOutlet weak var user2_logo: UIImageView!
}

class FaceOff_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let crypRef = Database.database().reference(withPath: "master_crypto")
    var cryp_loc_list: [NSDictionary] = []
    var cryp_loc_list_self: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "faceOffTVCTableViewCell", bundle: nil), forCellReuseIdentifier: "face")
        self.determineOpp()
        // Do any additional setup after loading the view.
    }
    
    func determineOpp() {
        Database.database().reference(withPath: "users").child(universalUserID).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
            
            if (snapshot.value != nil) {
                let value: NSDictionary = snapshot.value! as! NSDictionary
                print(value.value(forKey: "user_opponent")!)
                let opponent = value.value(forKey: "user_opponent")!
                
                Database.database().reference(withPath: "users").child(universalUserID).child("portfolio").queryOrdered(byChild: "portfolio")
                    .observeSingleEvent(of: .value, with: { snapshot in
                        
                        for child in snapshot.children.allObjects as? [DataSnapshot] ?? []{
                            
                            let value = child.value as! [String: Any]
                            
                            print(value)
                            
                            let crypDataSimp: [String: AnyObject] =  ["id":value["id"] as AnyObject, "quantity":value["quantity"] as AnyObject]
                            //                    self.cryp_id_list.append(crypDataSimp as NSDictionary)
                            
                            Database.database().reference(withPath: "name_crypto").child(value["id"] as! String).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
                                if (snapshot.value != nil) {
                                    let val:[String: AnyObject] =  [
                                        "24h_volume_usd":snapshot.childSnapshot(forPath: "24h_volume_usd").value as! String as AnyObject,
                                        "available_supply":snapshot.childSnapshot(forPath: "available_supply").value as! String as AnyObject,
                                        "id":snapshot.childSnapshot(forPath: "id").value as! String as AnyObject,
                                        "last_updated":snapshot.childSnapshot(forPath: "last_updated").value as! String as AnyObject,
                                        "market_cap_usd":snapshot.childSnapshot(forPath: "market_cap_usd").value as! String as AnyObject,
                                        "name":snapshot.childSnapshot(forPath: "name").value as! String as AnyObject,
                                        "percent_change_1h":snapshot.childSnapshot(forPath: "percent_change_1h").value as! String as AnyObject,
                                        "percent_change_24h":snapshot.childSnapshot(forPath: "percent_change_24h").value as! String as AnyObject,
                                        "percent_change_7d":snapshot.childSnapshot(forPath: "percent_change_7d").value as! String as AnyObject,
                                        "price_btc":snapshot.childSnapshot(forPath: "price_btc").value as! String as AnyObject,
                                        "price_usd":snapshot.childSnapshot(forPath: "price_usd").value as! String as AnyObject,
                                        "rank":snapshot.childSnapshot(forPath: "rank").value as! String as AnyObject,
                                        "symbol":snapshot.childSnapshot(forPath: "symbol").value as! String as AnyObject,
                                        "total_supply":snapshot.childSnapshot(forPath: "total_supply").value as! String as AnyObject,
                                        "user_quantity":value["quantity"] as! String as AnyObject]
                                    
                                    self.cryp_loc_list_self.append(val as NSDictionary)
                                    
                                }
                                else {
                                }
                                
                            Database.database().reference(withPath: "users").child(opponent as! String).child("portfolio").queryOrdered(byChild: "portfolio")
                                    .observeSingleEvent(of: .value, with: { snapshot in
                                        
                                        for child in snapshot.children.allObjects as? [DataSnapshot] ?? []{
                                            
                                            let value = child.value as! [String: Any]
                                            
                                            //                    print(value)
                                            
                                            let crypDataSimp: [String: AnyObject] =  ["id":value["id"] as AnyObject, "quantity":value["quantity"] as AnyObject]
                                            //                    self.cryp_id_list.append(crypDataSimp as NSDictionary)

                                            Database.database().reference(withPath: "name_crypto").child(value["id"] as! String).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
                                                if (snapshot.value != nil) {
                                                    let val:[String: AnyObject] =  [
                                                        "24h_volume_usd":snapshot.childSnapshot(forPath: "24h_volume_usd").value as! String as AnyObject,
                                                        "available_supply":snapshot.childSnapshot(forPath: "available_supply").value as! String as AnyObject,
                                                        "id":snapshot.childSnapshot(forPath: "id").value as! String as AnyObject,
                                                        "last_updated":snapshot.childSnapshot(forPath: "last_updated").value as! String as AnyObject,
                                                        "market_cap_usd":snapshot.childSnapshot(forPath: "market_cap_usd").value as! String as AnyObject,
                                                        "name":snapshot.childSnapshot(forPath: "name").value as! String as AnyObject,
                                                        "percent_change_1h":snapshot.childSnapshot(forPath: "percent_change_1h").value as! String as AnyObject,
                                                        "percent_change_24h":snapshot.childSnapshot(forPath: "percent_change_24h").value as! String as AnyObject,
                                                        "percent_change_7d":snapshot.childSnapshot(forPath: "percent_change_7d").value as! String as AnyObject,
                                                        "price_btc":snapshot.childSnapshot(forPath: "price_btc").value as! String as AnyObject,
                                                        "price_usd":snapshot.childSnapshot(forPath: "price_usd").value as! String as AnyObject,
                                                        "rank":snapshot.childSnapshot(forPath: "rank").value as! String as AnyObject,
                                                        "symbol":snapshot.childSnapshot(forPath: "symbol").value as! String as AnyObject,
                                                        "total_supply":snapshot.childSnapshot(forPath: "total_supply").value as! String as AnyObject,
                                                        "user_quantity":value["quantity"] as! String as AnyObject]
                                                    
                                                        self.cryp_loc_list.append(val as NSDictionary)
                                                        self.tableView.reloadData()

                                                }
                                                else {
                                                }
                                                
                                            }
                                            
                                        }
                                        print("DONE")
                                        
                                    })
                            }
                            
                            
                        }
                        print("DONE")
                    })
                
//                self.pullData(uid:(opponent as? String)!)
                
            }
            else {
                print("ERROR")
            }
        }
    }

//    func pullData(uid: String){
//
//        print("received \(uid)")
//
//        Database.database().reference(withPath: "users").child(uid).child("portfolio").queryOrdered(byChild: "portfolio")
//            .observeSingleEvent(of: .value, with: { snapshot in
//
//                for child in snapshot.children.allObjects as? [DataSnapshot] ?? []{
//
//                    let value = child.value as! [String: Any]
//
////                    print(value)
//
//                    let crypDataSimp: [String: AnyObject] =  ["id":value["id"] as AnyObject, "quantity":value["quantity"] as AnyObject]
////                    self.cryp_id_list.append(crypDataSimp as NSDictionary)
//
//                    Database.database().reference(withPath: "name_crypto").child(value["id"] as! String).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
//                        if (snapshot.value != nil) {
//                            let val:[String: AnyObject] =  [
//                                "24h_volume_usd":snapshot.childSnapshot(forPath: "24h_volume_usd").value as! String as AnyObject,
//                                "available_supply":snapshot.childSnapshot(forPath: "available_supply").value as! String as AnyObject,
//                                "id":snapshot.childSnapshot(forPath: "id").value as! String as AnyObject,
//                                "last_updated":snapshot.childSnapshot(forPath: "last_updated").value as! String as AnyObject,
//                                "market_cap_usd":snapshot.childSnapshot(forPath: "market_cap_usd").value as! String as AnyObject,
//                                "name":snapshot.childSnapshot(forPath: "name").value as! String as AnyObject,
//                                "percent_change_1h":snapshot.childSnapshot(forPath: "percent_change_1h").value as! String as AnyObject,
//                                "percent_change_24h":snapshot.childSnapshot(forPath: "percent_change_24h").value as! String as AnyObject,
//                                "percent_change_7d":snapshot.childSnapshot(forPath: "percent_change_7d").value as! String as AnyObject,
//                                "price_btc":snapshot.childSnapshot(forPath: "price_btc").value as! String as AnyObject,
//                                "price_usd":snapshot.childSnapshot(forPath: "price_usd").value as! String as AnyObject,
//                                "rank":snapshot.childSnapshot(forPath: "rank").value as! String as AnyObject,
//                                "symbol":snapshot.childSnapshot(forPath: "symbol").value as! String as AnyObject,
//                                "total_supply":snapshot.childSnapshot(forPath: "total_supply").value as! String as AnyObject,
//                                "user_quantity":value["quantity"] as! String as AnyObject]
//
//                            self.cryp_loc_list.append(val as NSDictionary)
//
//                        }
//                        else {
//                        }
//                        self.tableView.reloadData()
//
//                    }
//                }
//                print("DONE")
//
//            })
//
//        Database.database().reference(withPath: "users").child(universalUserID).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
//            if (snapshot.value != nil) {
//                let value: NSDictionary = snapshot.value! as! NSDictionary
//                print(value.value(forKey: "user_name")!)
//                let userCash = value.value(forKey: "user_cash")! as! Double
//                print(userCash)
//            }
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return cryp_loc_list_self.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "face", for: indexPath) as! faceOff_custom_cell
        cell.selectionStyle = .none
        let currentEvent = cryp_loc_list_self[indexPath.row]
        let currentEvent2 = cryp_loc_list[indexPath.row]

        
        //        let value_pars = currentEvent.value(forKey: "percent_change_24h") as? String
        //        let value_float = Double(value_pars!)
        
        //        var arrow_dir = ""
        //
        //        if (Double(value_float!) > 0) {
        //            print("POSITIVE CHANGE")
        //            arrow_dir = "uarrow.png"
        //        }
        //        else {
        //            print("NEGATIVE CHANGE")
        //            arrow_dir = "darrow.png"
        //        }
        
        //        print((currentEvent.value(forKey: "id") as? String)!)
        
        cell.user1_logo.image = UIImage(named:"\((currentEvent.value(forKey: "id") as? String)!).png")
        cell.user1_label.text = currentEvent.value(forKey: "name") as? String
        cell.user2_logo.image = UIImage(named:"\((currentEvent2.value(forKey: "id") as? String)!).png")
        cell.user2_label.text = currentEvent2.value(forKey: "name") as? String
       
        cell.backgroundColor = UIColor.clear
        self.tableView.rowHeight = 120.0
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
