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
    @IBOutlet weak var stockChart: LineChartView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceText: UILabel!
    
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
        if(grab == "bitcoin") {
            path = "history_crypto/c0"
        }
        if(grab == "ethereum") {
            path = "history_crypto/c1"
        }
        if(grab == "bitcoin cash") {
            path = "history_crypto/c2"
        }
        if(grab == "ripple") {
            path = "history_crypto/c3"
        }
        if(grab == "dash") {
            path = "history_crypto/c4"
        }
        if(grab == "litecoin") {
            path = "history_crypto/c5"
        }
        if(grab == "nem") {
            path = "history_crypto/c6"
        }
        if(grab == "iota") {
            path = "history_crypto/c7"
        }
        if(grab == "steem") {
            path = "history_crypto/c8"
        }
        if(grab == "ethereum classic") {
            path = "history_crypto/c9"
        }
        if(grab == "neo") {
            path = "history_crypto/c10"
        }
        if(grab == "omisego") {
            path = "history_crypto/c11"
        }
        if(grab == "bitconnect") {
            path = "history_crypto/c12"
        }
        if(grab == "lisk") {
            path = "history_crypto/c13"
        }
        if(grab == "qtum") {
            path = "history_crypto/c14"
        }
        if(grab == "zcash") {
            path = "history_crypto/c15"
        }
        if(grab == "tether") {
            path = "history_crypto/c16"
        }
        if(grab == "stratis") {
            path = "history_crypto/c17"
        }
        if(grab == "waves") {
            path = "history_crypto/c18"
        }
        if(grab == "ark") {
            path = "history_crypto/c19"
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
                        if( i == snapshot.childrenCount - 2) {
           
                            var tmp = String(format: "%.2f", Double(value)!)
                            self.priceText.text = "$" + tmp
                        }
                    }
                    i += 1;
                   }
        })
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
