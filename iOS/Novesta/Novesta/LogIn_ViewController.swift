//
//  LogIn_ViewController.swift
//  Novesta
//
//  Created by Brian Lin on 9/23/17.
//  Copyright © 2017 Brian Lin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LogIn_ViewController: UIViewController {

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        try! Auth.auth().signOut()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if Auth.auth().currentUser != nil {
            print("user is signed in")
            let UID = Auth.auth().currentUser?.uid
            let newPth = Database.database().reference(withPath: "users").child(UID!)
            universalUserID = UID!
            
            print(newPth)
            
            
            self.performSegue(withIdentifier: "toMain", sender: nil)
            
        } else {
            print("user is NOT signed in")
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
    @IBAction func pressedSignIn(_ sender: Any) {
        print("pressed")
        Auth.auth().signIn(withEmail: self.userNameTF.text!, password: self.passwordTF.text!) { (user, error) in
            if user != nil {
                print("sign in successful")
                let newPth = Database.database().reference(withPath: "users").child((user?.uid)!)
                
                universalUserID = (user?.uid)!
                
                newPth.child("user_name").setValue("Brian")

                
                self.performSegue(withIdentifier: "toMain", sender: nil)
            }
            else{
                print("sign in failed")
                
            }
        }
        
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
