//
//  ViewController.swift
//  SideMenuDemo
//
//  Created by Sharad Goyal on 31/07/18.
//  Copyright © 2018 Sharad Goyal. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    lazy var pieChart: PieChartView = {
        let p = PieChartView()
        p.noDataText = "No Data to display"
        p.translatesAutoresizingMaskIntoConstraints = false
        p.legend.enabled = false
        p.chartDescription?.text = ""
        p.drawHoleEnabled = false
        p.delegate = self
        
        return p
    }()
    
    let surveyData = ["Cat": 20, "Dog": 30, "Both": 15, "Neither": 35]
    
    private func setUpPieChart() {
        view.addSubview(pieChart)
        pieChart.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        pieChart.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        pieChart.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        pieChart.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
        
    }
    
    private func fillChart() {
        var dataEntries = [PieChartDataEntry]()
        for (key, val) in surveyData {
            let entry = PieChartDataEntry(value: Double(val), label: key)
            dataEntries.append(entry)
        }
        
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "")
        chartDataSet.colors = ChartColorTemplates.material()
        chartDataSet.sliceSpace = 2
        chartDataSet.selectionShift = 5
        
        let chartData = PieChartData(dataSet: chartDataSet)
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        chartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        
        pieChart.data = chartData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPieChart()
        fillChart()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let index = highlight.y
        print("Selected Index: \(index)")
    }
}

