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

class League_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpDataBase()
        
        
        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
