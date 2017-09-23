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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var portfolioWorth: UILabel!
    
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
        let creationPath = Database.database().reference(withPath: "users").child(universalUserID).child("portfolio").child((cryp_loc_list[14].value(forKey: "id") as? String)!)

        creationPath.setValue(cryp_loc_list[14])
        
        print("NEW DATA SENT")
        
    }

    func pullData(){
        Database.database().reference(withPath: "users").child(universalUserID).child("portfolio").queryOrdered(byChild: "portfolio")
            .observeSingleEvent(of: .value, with: { snapshot in
                
                for child in snapshot.children.allObjects as? [DataSnapshot] ?? []{
                    let crypDataSimp: [String: AnyObject] =  [
                        "24h_volume_usd":child.childSnapshot(forPath: "24h_volume_usd").value as! String as AnyObject,
                        "available_supply":child.childSnapshot(forPath: "available_supply").value as! String as AnyObject,
                        "id":child.childSnapshot(forPath: "id").value as! String as AnyObject,
                        "last_updated":child.childSnapshot(forPath: "last_updated").value as! String as AnyObject,
                        "market_cap_usd":child.childSnapshot(forPath: "market_cap_usd").value as! String as AnyObject,
                        "name":child.childSnapshot(forPath: "name").value as! String as AnyObject,
                        "percent_change_1h":child.childSnapshot(forPath: "percent_change_1h").value as! String as AnyObject,
                        "percent_change_24h":child.childSnapshot(forPath: "percent_change_24h").value as! String as AnyObject,
                        "percent_change_7d":child.childSnapshot(forPath: "percent_change_7d").value as! String as AnyObject,
                        "price_btc":child.childSnapshot(forPath: "price_btc").value as! String as AnyObject,
                        "price_usd":child.childSnapshot(forPath: "price_usd").value as! String as AnyObject,
                        "rank":child.childSnapshot(forPath: "rank").value as! String as AnyObject,
                        "symbol":child.childSnapshot(forPath: "symbol").value as! String as AnyObject,
                        "total_supply":child.childSnapshot(forPath: "total_supply").value as! String as AnyObject]
                    
                    self.cryp_loc_list.append(crypDataSimp as NSDictionary)
                    self.tableView.reloadData()
                    
                    self.updateWorth()
                }
                print("DONE")
            })
        
    }
    
    var portfolio_netWorth: Double {
        
        var total = 0.0

        for indiv in self.cryp_loc_list {
            print("RAN")

            let double_value = indiv.value(forKey: "price_usd")! as? String
            print(double_value!)
            total += Double(double_value!)!
        }
        
        return total
    }
    
    func updateWorth (){
        portfolioWorth.text = String(self.portfolio_netWorth)
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
            print("NEGATIVE CHANGE")
//            arrow_dir = "darrow.png"
        }
        
//        print((currentEvent.value(forKey: "id") as? String)!)
        
        cell.cryp_name.text = currentEvent.value(forKey: "name") as? String
        cell.cryp_flunc_logo.image = UIImage(named: arrow_dir)
        cell.cryp_flunc_value.text = currentEvent.value(forKey: "percent_change_24h") as? String
        cell.cryp_logo.image = UIImage(named: "\((currentEvent.value(forKey: "id") as? String)!).png")
        cell.backgroundColor = UIColor.clear
        self.tableView.rowHeight = 90.0
        
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
