//
//  buy_and_sell_ViewController.swift
//  Novesta
//
//  Created by Abhitej R Ganta on 9/24/17.
//  Copyright © 2017 Brian Lin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class buy_and_sell_ViewController: UIViewController {
    let crypRef = Database.database().reference(withPath: "master_crypto")
    var cryp_loc_list: [NSDictionary] = []
    var cryp_id_list: [NSDictionary] = []
    
    @IBOutlet weak var portfolioWorth: UILabel!
    @IBOutlet weak var portfolioGrowth: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func pullData(){
        Database.database().reference(withPath: "users").child(universalUserID).child("portfolio").queryOrdered(byChild: "portfolio")
            .observeSingleEvent(of: .value, with: { snapshot in
                
                for child in snapshot.children.allObjects as? [DataSnapshot] ?? []{
                    
                    let value = child.value as! [String: Any]
                    
                    print(value)
                    
                    let crypDataSimp: [String: AnyObject] =  ["id":value["id"] as AnyObject, "quantity":value["quantity"] as AnyObject]
                    self.cryp_id_list.append(crypDataSimp as NSDictionary)
                    
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
                            
                        }
                        else {
                        }
                    }
                    
                }
                
                print("DONE")
            })
        
        var portfolio_netGrowth: Double {
            
            var total = 0.0
            
            for indiv in self.cryp_loc_list {
                print("RAN_Growth")
                
                let double_value = indiv.value(forKey: "price_usd")! as? String
                let double_quantity = indiv.value(forKey: "user_quantity") as? String
                let double_growth = indiv.value(forKey: "percent_change_24h") as? String
                print(double_value!)
                total += (Double(double_value!)! * Double(double_quantity!)!) / self.portfolio_netWorth * Double(double_growth!)!
            }
        
        func updateWorth (){
            portfolioWorth.text = "$\(String(self.portfolio_netWorth))"
            portfolioGrowth.text = "\(String(self.portfolio_netGrowth))%"
            
            
            let creationPath = Database.database().reference(withPath: "users").child(universalUserID).child("net_worth")
            creationPath.setValue(self.portfolio_netWorth)
            let creationPath2 = Database.database().reference(withPath: "users").child(universalUserID).child("net_growth")
            print("NET GROWTH>>>>>>>>> \(self.portfolio_netGrowth)")
            creationPath2.setValue(self.portfolio_netGrowth)
        }
        
    }
}
