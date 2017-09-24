//
//  StockViewController.swift
//  Novesta
//
//  Created by Pop Pro on 9/23/17.
//  Copyright © 2017 Brian Lin. All rights reserved.
//

import UIKit
import Charts
import Firebase

class StockViewController: UIViewController {

    var grab : String!;
    var prices = [Double]()
    var playerCash = 0.0;
    var currency = "0";
    var cost = 0.0;
    var portPath = -1
    var numChild = -1;
    var name = ""
    
    var state = -1; //-1 nothing, 0 selling, 1 buying
    
    @IBOutlet weak var stockChart: LineChartView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var hrChangeLabel: UILabel!
    
    @IBOutlet weak var dimmer: UIView!
    @IBOutlet weak var amountIn: UITextField!
    @IBOutlet weak var subButton: UIButton!
    
    
    @IBAction func swipedDown(_ sender: Any) {
        self.performSegue(withIdentifier: "back", sender: nil);
    }
    
    let crypRef = Database.database().reference(withPath: "history_crypto")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = grab.uppercased() + " (USD)";
        getData()
        setUpChart()
        updateChart()
        
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.updateChart), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateChart() {
        var cpuDataR: [ChartDataEntry] = []
        for i in 0..<prices.count {
            cpuDataR.append(ChartDataEntry(x: Double(i), y: prices[i]))
        }
        
        let cpuDataSet = LineChartDataSet(values: cpuDataR, label: "USD")
        cpuDataSet.colors = [UIColor(red: 0/255, green: 197/255, blue: 0/255, alpha: 1)]
        cpuDataSet.drawCubicEnabled = true
        cpuDataSet.drawValuesEnabled = false
        cpuDataSet.drawCirclesEnabled = false
        
        let cpuData = LineChartData(dataSet: cpuDataSet)
        stockChart.data = cpuData;
    }
    
    func setUpChart() {
        stockChart.gridBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        stockChart.chartDescription?.text = ""
        stockChart.legend.enabled = false;
        stockChart.isUserInteractionEnabled = false;
        stockChart.drawBordersEnabled = false;
        stockChart.drawMarkers = false
        stockChart.leftAxis.drawGridLinesEnabled = false
        stockChart.leftAxis.labelTextColor = #colorLiteral(red: 0.1450774968, green: 0.1451098621, blue: 0.1450754404, alpha: 1)
        stockChart.rightAxis.drawLabelsEnabled = false
        stockChart.rightAxis.drawGridLinesEnabled = false
        stockChart.rightAxis.drawAxisLineEnabled = false
        stockChart.xAxis.drawGridLinesEnabled = false;
        stockChart.xAxis.drawLabelsEnabled = true
        stockChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        //stockChart.leftAxis.axisMinimum = 0;
        //CPUChart.leftAxis.axisMaximum = 100;
        stockChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    func getData() {
        var path : String?
        var pathData : String?
        if(grab == "bitcoin") {
            path = "history_crypto/c0"
            pathData = "name_crypto/" + grab
        }
        if(grab == "ethereum") {
            path = "history_crypto/c1"
            pathData = "name_crypto/" + grab
        }
        if(grab == "bitcoin cash") {
            path = "history_crypto/c2"
            pathData = "name_crypto/bitcoin-cash"
        }
        if(grab == "ripple") {
            path = "history_crypto/c3"
            pathData = "name_crypto/" + grab
        }
        if(grab == "dash") {
            path = "history_crypto/c4"
            pathData = "name_crypto/" + grab
        }
        if(grab == "litecoin") {
            path = "history_crypto/c5"
            pathData = "name_crypto/" + grab
        }
        if(grab == "nem") {
            path = "history_crypto/c6"
            pathData = "name_crypto/" + grab
        }
        if(grab == "iota") {
            path = "history_crypto/c7"
            pathData = "name_crypto/" + grab
        }
        if(grab == "steem") {
            path = "history_crypto/c8"
            pathData = "name_crypto/" + grab
        }
        if(grab == "ethereum classic") {
            path = "history_crypto/c9"
            pathData = "name_crypto/ethereum-classic"
        }
        if(grab == "neo") {
            path = "history_crypto/c10"
            pathData = "name_crypto/" + grab
        }
        if(grab == "omisego") {
            path = "history_crypto/c11"
            pathData = "name_crypto/" + grab
        }
        if(grab == "bitconnect") {
            path = "history_crypto/c12"
            pathData = "name_crypto/" + grab
        }
        if(grab == "lisk") {
            path = "history_crypto/c13"
            pathData = "name_crypto/" + grab
        }
        if(grab == "qtum") {
            path = "history_crypto/c14"
            pathData = "name_crypto/" + grab
        }
        if(grab == "zcash") {
            path = "history_crypto/c15"
            pathData = "name_crypto/" + grab
        }
        if(grab == "tether") {
            path = "history_crypto/c16"
            pathData = "name_crypto/" + grab
        }
        if(grab == "stratis") {
            path = "history_crypto/c17"
            pathData = "name_crypto/" + grab
        }
        if(grab == "waves") {
            path = "history_crypto/c18"
            pathData = "name_crypto/" + grab
        }
        if(grab == "ark") {
            path = "history_crypto/c19"
            pathData = "name_crypto/" + grab
        }
    
        
        print(path)
        
        Database.database().reference(withPath: path!).queryOrderedByKey()
            .observeSingleEvent(of: .value, with: { snapshot in
                var i = 0
                for child in snapshot.children.allObjects as? [DataSnapshot] ?? []{
                    let value = child.value as! String
                    self.updateChart()
                    if(i < snapshot.childrenCount - 1) {
                        self.prices.append(Double(value)!);
                    }
                    i += 1;
                   }
        })
        
        Database.database().reference(withPath: pathData!).queryOrderedByKey()
            .observeSingleEvent(of: .value, with: { snapshot in
                var a = snapshot.childSnapshot(forPath: "price_usd").value as! String!;
                var tmp = String(format: "%.2f", Double(a!)!)
                self.priceText.text = "$" + tmp
                
                self.cost = Double(a!)!;
                
                a = snapshot.childSnapshot(forPath: "percent_change_24h").value as! String!;
                if(Double(a!)! < 0) {
                    self.hrChangeLabel.textColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
                }
                self.hrChangeLabel.text = a! + "%"
            })
        
        Database.database().reference(withPath: "users").child(universalUserID).child("portfolio").queryOrdered(byChild: "portfolio")
            .observeSingleEvent(of: .value, with: { snapshot in
                
                var i = 0;
                
                self.numChild = Int(snapshot.childrenCount);
                
                for child in snapshot.children.allObjects as? [DataSnapshot] ?? []{
                    
                    var a = child.childSnapshot(forPath: "id").value as! String!;
                    
                    if(a! == self.grab) {
                        self.currency = child.childSnapshot(forPath: "quantity").value as! String;
                        self.portPath = i;
                    }
                    i+=1
                }
        })
        
        Database.database().reference(withPath: "users").child(universalUserID)
            .observeSingleEvent(of: .value, with: { snapshot in
                
                //for child in snapshot.children.allObjects as? [DataSnapshot] ?? []{
                    
                    var a = snapshot.childSnapshot(forPath: "user_cash").value as? String!
                self.playerCash = snapshot.childSnapshot(forPath: "user_cash").value as! Double;
                    
                //}
            })
    }
    
    @IBAction func buyPressed(_ sender: Any) {
        dimmer.alpha = 0.4;
        subButton.alpha = 1;
        amountIn.alpha = 1;
        state = 1;
    }
    
    @IBAction func sellPressed(_ sender: Any) {
        dimmer.alpha = 0.4;
        subButton.alpha = 1;
        amountIn.alpha = 1;
        state = 0;
    }
    
    
    @IBAction func submitPressed(_ sender: Any) {
        dimmer.alpha = 0;
        subButton.alpha = 0;
        
        if(state == 0) {
            if(amountIn.text != "") {
                if(Double(currency)! - Double(amountIn.text!)! >= 0) {
                    let profit = Double(amountIn.text!)! * cost
                    playerCash += profit;
                    let x = Double(currency)! - Double(amountIn.text!)!
                    currency = String(x)
                    
                    let creationPath = Database.database().reference(withPath: "users").child(universalUserID).child("user_cash")
                
                    creationPath.setValue(self.playerCash)
                    
                    let creationPath2 = Database.database().reference(withPath: "users").child(universalUserID).child("portfolio").child(String(portPath)).child("quantity")
                    creationPath2.setValue(self.currency)
                    
                }
            }
        } else if(state == 1) {
            if(amountIn.text != "") {
                if(playerCash - Double(amountIn.text!)! * cost >= 0) {
                    let loss = Double(amountIn.text!)! * cost
                    playerCash -= loss;
                    let x = Double(currency)! + Double(amountIn.text!)!
                    currency = String(x)
                    
                    let creationPath = Database.database().reference(withPath: "users").child(universalUserID).child("user_cash")
                    
                    creationPath.setValue(self.playerCash)
                    
                    if(portPath != -1) {
                    let creationPath2 = Database.database().reference(withPath: "users").child(universalUserID).child("portfolio").child(String(portPath)).child("quantity")
                    creationPath2.setValue(self.currency)
                    } else {
                        let creationPath2 = Database.database().reference(withPath: "users").child(universalUserID).child("portfolio").child(String(numChild)).child("quantity")
                        creationPath2.setValue(self.currency)
                        
                        let creationPath3 = Database.database().reference(withPath: "users").child(universalUserID).child("portfolio").child(String(numChild)).child("id")
                        if(self.grab != "bitcoin cash" || self.grab != "ethereum classic") {
                            creationPath3.setValue(self.grab)
                        } else if(self.grab == "bitcoin cash"){
                            creationPath3.setValue("bitcoin-cash")
                        } else {
                            creationPath3.setValue("ethereum-classic")
                        }
                    }
                }
            }
        }
        
        viewDidLoad()
        
        amountIn.text = ""
        amountIn.alpha = 0;
        
        
        state = -1;
    }
    
    func buyCoin() {
        
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
