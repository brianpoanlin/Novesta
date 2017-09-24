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
    
    let crypRef = Database.database().reference(withPath: "history_crypto")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        //setUpChart()
        //updateChart()
        print(grab)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateChart() {
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
        stockChart.leftAxis.labelTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        stockChart.rightAxis.drawLabelsEnabled = false
        stockChart.rightAxis.drawGridLinesEnabled = false
        stockChart.rightAxis.drawAxisLineEnabled = false
        stockChart.xAxis.drawGridLinesEnabled = false;
        stockChart.xAxis.drawLabelsEnabled = false
        stockChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        stockChart.leftAxis.axisMinimum = 0;
        //CPUChart.leftAxis.axisMaximum = 100;
        stockChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    func getData() {
        var path : String?
        if(grab == "bitcoin") {
            path = "history_crypto/c0"
        }
    
        
        print(path)
        
        Database.database().reference(withPath: path!).queryOrderedByKey()
            .observeSingleEvent(of: .value, with: { snapshot in
                var i = 0
                for child in snapshot.children.allObjects as? [DataSnapshot] ?? []{
                    
                    let value = child.value as! String
                    
                    print(value)
                    
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
