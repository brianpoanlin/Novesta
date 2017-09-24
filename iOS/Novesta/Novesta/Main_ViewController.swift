//
//  Main_ViewController.swift
//  Novesta
//
//  Created by Brian Lin on 9/23/17.
//  Copyright © 2017 Brian Lin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class cryp_tbl_view_cell: UITableViewCell {
    
    @IBOutlet weak var cryp_name: UILabel!
    @IBOutlet weak var cryp_logo: UIImageView!
    @IBOutlet weak var cryp_flunc_logo: UIImageView!
    @IBOutlet weak var cryp_flunc_value: UILabel!
    
}

class Main_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let crypRef = Database.database().reference(withPath: "master_crypto")
    var cryp_loc_list: [NSDictionary] = []
    var cryp_id_list: [NSDictionary] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var portfolioWorth: UILabel!
    @IBOutlet weak var portfolioGrowth: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "Novesta_TableViewCell", bundle: nil), forCellReuseIdentifier: "cryp")
        
        self.pullData()
//        setUpDataBase()
    }
    
    @IBAction func swiped_left(_ sender: Any) {
        self.performSegue(withIdentifier: "main_to_market", sender: nil)
        print("SWIPPPPPPPEEEEE")
//        setUpDataBase()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func setUpDataBase() {
        let creationPath = Database.database().reference(withPath: "users").child(universalUserID).child("portfolio").child((cryp_loc_list[5].value(forKey: "id") as? String)!)

        creationPath.setValue(cryp_loc_list[5])
        
        print("NEW DATA SENT")
        
    }

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
                            
                            self.tableView.reloadData()
                            
                        }
                        else {
                        }
                    }
                    
                }

                print("DONE")
            })


    }
    
    func fetchCrypFullData() {
        
        for ind in self.cryp_id_list {
            Database.database().reference(withPath: "name_crypto").child((ind.value(forKey: "id") as? String)!).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
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
                        "total_supply":snapshot.childSnapshot(forPath: "total_supply").value as! String as AnyObject]
                    
                    self.cryp_loc_list.append(val as NSDictionary)
                    
                    self.tableView.reloadData()

                }
                else {
                }
            }
        }
    }
    
    var portfolio_netWorth: Double {
        
        var total = 0.0

        for indiv in self.cryp_loc_list {
            print("RAN")

            let double_value = indiv.value(forKey: "price_usd")! as? String
            let double_quantity = indiv.value(forKey: "user_quantity") as? String
            print(double_value!)
            total += (Double(double_value!)! * Double(double_quantity!)!)
        }
        
        total=round(100*total)/100
        
        return total
    }
    
//    sum = sum + ( (quantity * structure) / (portfoliovalue) * growth rate);
    
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
        
        total=round(100*total)/100
        
        return total
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return self.cryp_loc_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cryp", for: indexPath) as! cryp_tbl_view_cell
        cell.selectionStyle = .none
        let currentEvent = cryp_loc_list[indexPath.row]
        
        let value_pars = currentEvent.value(forKey: "percent_change_24h") as? String
        let value_float = Double(value_pars!)
        
        var arrow_dir = ""
        
        if (Double(value_float!) > 0) {
//            print("POSITIVE CHANGE")
            arrow_dir = "uarrow.png"
        }
        else {
//            print("NEGATIVE CHANGE")
            arrow_dir = "darrow.png"
        }
        
//        print((currentEvent.value(forKey: "id") as? String)!)
        
        cell.cryp_name.text = currentEvent.value(forKey: "name") as? String
        cell.cryp_flunc_logo.image = UIImage(named: arrow_dir)
        cell.cryp_flunc_value.text = "\((currentEvent.value(forKey: "percent_change_24h") as? String)!)%"
        cell.cryp_logo.image = UIImage(named: "\((currentEvent.value(forKey: "id") as? String)!).png")
        cell.backgroundColor = UIColor.clear
        self.tableView.rowHeight = 90.0
        
        self.updateWorth()
        
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
