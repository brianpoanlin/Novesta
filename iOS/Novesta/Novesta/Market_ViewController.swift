//
//  Market_ViewController.swift
//  Novesta
//
//  Created by Brian Lin on 9/23/17.
//  Copyright © 2017 Brian Lin. All rights reserved.
//

import UIKit
import Firebase

class Market_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let crypRef = Database.database().reference(withPath: "master_crypto")
    var cryp_loc_list: [NSDictionary] = []
    @IBOutlet weak var tableView: UITableView!
    var holdInfo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "Novesta_TableViewCell", bundle: nil), forCellReuseIdentifier: "cryp")
        self.pullData()

        // Do any additional setup after loading the view.
    }
    @IBAction func swipeToMain(_ sender: Any) {
//        self.populateData()

        self.performSegue(withIdentifier: "market_to_main", sender: nil)
    }
    
    @IBAction func swiped_left(_ sender: Any) {
        
        self.performSegue(withIdentifier: "market_to_league", sender: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateData() {
        let creationPath = Database.database().reference(withPath: "users").child(universalUserID).child("portfolio")
        
        creationPath.setValue([["id":cryp_loc_list[3].value(forKey: "id") as AnyObject,"quantity":"10"],["id":cryp_loc_list[16].value(forKey: "id") as AnyObject,"quantity":"1"],["id":cryp_loc_list[15].value(forKey: "id") as AnyObject,"quantity":"12"],["id":cryp_loc_list[2].value(forKey: "id") as AnyObject,"quantity":"6"],["id":cryp_loc_list[7].value(forKey: "id") as AnyObject,"quantity":"4"]])
        
        print("NEW DATA SENT")
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func pullData(){
        crypRef.queryOrdered(byChild: "master_crypto")
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
                    
                }
                print("DONE")
            })
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
            print("POSITIVE CHANGE")
            arrow_dir = "uarrow.png"
        }
        else {
            print("NEGATIVE CHANGE")
            arrow_dir = "darrow.png"
        }
        
        print((currentEvent.value(forKey: "id") as? String)!)
        
        cell.cryp_name.text = currentEvent.value(forKey: "name") as? String
        cell.cryp_flunc_logo.image = UIImage(named: arrow_dir)
        cell.cryp_flunc_value.text = currentEvent.value(forKey: "percent_change_24h") as? String
        cell.cryp_logo.image = UIImage(named: "\((currentEvent.value(forKey: "id") as? String)!).png")
        cell.backgroundColor = UIColor.clear
        self.tableView.rowHeight = 90.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let curr = tableView.cellForRow(at: indexPath) as? cryp_tbl_view_cell;
        holdInfo = curr?.cryp_name.text?.lowercased() as! String
        self.performSegue(withIdentifier: "toInfo", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewControllerB = segue.destination as? StockViewController {
            viewControllerB.grab = holdInfo
        }
        
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
