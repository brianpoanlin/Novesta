//
//  League_ViewController.swift
//  Novesta
//
//  Created by Brian Lin on 9/23/17.
//  Copyright © 2017 Brian Lin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class league_custom_cell: UITableViewCell {
    @IBOutlet weak var ranking_label: UILabel!
    @IBOutlet weak var username_label: UILabel!
    @IBOutlet weak var networth_label: UILabel!
    @IBOutlet weak var flunc_arrow: UIImageView!
    @IBOutlet weak var netgrowth_label: UILabel!
}

class League_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let crypRef = Database.database().reference(withPath: "League")
    var cryp_loc_listofusers: [NSDictionary] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "Novesta_TableViewCell", bundle: nil), forCellReuseIdentifier: "cryp")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.pullData()
        print("screen loaded")


    }
    
    func pullData(){
        crypRef.queryOrdered(byChild: "League")
            .observeSingleEvent(of: .value, with: { snapshot in
                
                for child in snapshot.children.allObjects as? [DataSnapshot] ?? []{
                    
                    print(child.childSnapshot(forPath: "members"))
                    let array = child.childSnapshot(forPath: "members").value as! [AnyObject]
                    print(array)
                    
                    for indiv in array {
                        print(Database.database().reference(withPath: "users").child(indiv as! String))
                        Database.database().reference(withPath: "users").child(indiv as! String).observeSingleEvent(of: .value) { (snapshot:DataSnapshot) in
                        if (snapshot.value! != nil) {
                            let name = child.childSnapshot(forPath: "user_name").value as! String
                            print(name)
                        }
                        else {
                        }
                        }
                    }
                    
                    self.tableView.reloadData()
                    
                    print("DONE")

                }
            })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func setUpDataBase() {
        let creationPath = Database.database().reference(withPath: "League").childByAutoId().child("members")
        creationPath.setValue(["nEX7BzN584adgw8Z1plmxX3mSK53","oldoBu4r0AeadnP8jxKSxvxz39A3"])
        
        print("NEW DATA SENT")
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
        return self.cryp_loc_listofusers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cryp", for: indexPath) as! cryp_tbl_view_cell
        cell.selectionStyle = .none
        let currentEvent = cryp_loc_listofusers[indexPath.row]
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
