//
//  Main_ViewController.swift
//  Novesta
//
//  Created by Brian Lin on 9/23/17.
//  Copyright © 2017 Brian Lin. All rights reserved.
//

import UIKit
import Firebase

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "Novesta_TableViewCell", bundle: nil), forCellReuseIdentifier: "cryp")
        
        self.pullData()
//        setUpDataBase()
        // Do any additional setup after loading the view.
    }
    
    func setUpDataBase (){
        let creationPath = Database.database().reference(withPath: "master_crypto").childByAutoId()
        
        let newNovestData:[String: AnyObject] = ["cryp_name":"Google" as AnyObject, "cryp_value":"10.202" as AnyObject]
        
        creationPath.setValue(newNovestData)
        print("NEW DATA SENT")
        
    }

    func pullData(){
        crypRef.queryOrdered(byChild: "master-crypto")
            .observeSingleEvent(of: .value, with: { snapshot in
                
                for child in snapshot.children.allObjects as? [DataSnapshot] ?? []{
                    
                    let crypDataSimp: [String: AnyObject] =  ["cryp_name":child.childSnapshot(forPath: "cryp_name").value as! String as AnyObject,
                                                              "cryp_value":child.childSnapshot(forPath: "cryp_value").value as! String as AnyObject]
                    
                    self.cryp_loc_list.append(crypDataSimp as NSDictionary)
                    self.tableView.reloadData()
                }
                print("DONE")
            })
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
        
        cell.cryp_name.text = currentEvent.value(forKey: "cryp_name") as? String
        cell.cryp_flunc_logo.image = UIImage(named: "bit_icon.png")
        cell.cryp_flunc_value.text = currentEvent.value(forKey: "cryp_value") as? String
        cell.cryp_logo.image = UIImage(named: "bit_icon.PNG")
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
