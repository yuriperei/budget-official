//
//  DashboardViewController.swift
//  Budget
//
//  Created by md10 on 3/18/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import Charts

class DashboardViewController: UIViewController {

    @IBOutlet weak var lblBalancoTotal: UILabel!
    @IBOutlet weak var lblTotalDespesas: UILabel!
    @IBOutlet weak var lblTotalReceitas: UILabel!
    @IBOutlet var btnMenuSidebar: UIBarButtonItem!
    @IBOutlet var lineChart: LineChartView!
    @IBOutlet var pieChartDespesas: PieChartView!
    @IBOutlet var pieChartReceitas: PieChartView!
    let dashboard:Dashboard = Dashboard()
    var drawChartLoaded:Bool = false
//    var zoom:CGFloat = 0.0
    func initDashboard(){
        lblBalancoTotal.text = dashboard.getTotalBalanco().convertToCurrency("pt_BR")
        lblTotalReceitas.text = dashboard.getTotalReceitas().convertToCurrency("pt_BR")
        lblTotalDespesas.text = dashboard.getTotalDespesas().convertToCurrency("pt_BR")
        
        let (months, receitasMensal, despesasMensal) = dashboard.getBalancoAnual()
        let (despesas, valorDespesas) = dashboard.getDespesasPorCategoria()
        let (receitas, valorReceitas) = dashboard.getReceitasPorCategoria()
//        print(Dashboard.getDespesasPorCategoria())
//        print(Dashboard.getReceitasPorCategoria())
        
        setLineBalanco(months, values: [receitasMensal, despesasMensal])
        
        
        if(valorDespesas.count > 0){
            setPieChart(despesas, values: valorDespesas, pieChart: pieChartDespesas)
        } else {
            pieChartDespesas.noDataText = "Não existem despesas\nregistradas esse mês"
        }
        
        if(valorReceitas.count > 0) {
            setPieChart(receitas, values: valorReceitas, pieChart: pieChartReceitas)
        } else {
            pieChartReceitas.noDataText = "Não existem receitas\nregistradas esse mês"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SidebarMenu.configMenu(self, sideBarMenu: btnMenuSidebar)
        drawBarChartBalanco()
    }
    
    private func drawBarChartBalanco() {
        let xAxis = lineChart.xAxis
        xAxis.labelPosition = .Bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.spaceBetweenLabels = 2
        
        let leftAxis = lineChart.leftAxis
        leftAxis.labelPosition = .OutsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.customAxisMin = 0
        leftAxis.labelFont = UIFont(name: "Futura", size: 10.0)!
        
        let rightAxis = lineChart.rightAxis
        rightAxis.enabled = true
        rightAxis.drawGridLinesEnabled = false
        rightAxis.spaceTop = 0.15
        rightAxis.customAxisMin = 0
        rightAxis.labelFont = leftAxis.labelFont
        
        lineChart.legend.position = .BelowChartLeft
        lineChart.legend.form = .Square
        lineChart.legend.formSize = 9.0
        lineChart.legend.xEntrySpace = 4.0
        lineChart.descriptionText = ""
    }
    
    private func setLineBalanco(months: [String], values: [[Double]]) {
        lineChart.noDataText = "Não foi possível carregar os dados."
        
        var dataEntries: [ChartDataEntry] = []
        var dataEntries2: [ChartDataEntry] = []
        
        for i in 0..<months.count {
            dataEntries.append(ChartDataEntry(value: values[0][i], xIndex: i))
            dataEntries2.append(ChartDataEntry(value: values[1][i], xIndex: i))
        }
        
        let setReceitas = LineChartDataSet(yVals: dataEntries, label: "Receitas")
        let setDespesas = LineChartDataSet(yVals: dataEntries2, label: "Despesas")
        let lineChartData = LineChartData(xVals: months, dataSets: [setReceitas, setDespesas])
        lineChart.data = lineChartData
        
        setReceitas.axisDependency = .Left;
        setReceitas.setColor(Color.uicolorFromHex(0x2C4E6E))
        setReceitas.lineWidth = 2.0
        setReceitas.circleRadius = 3.0
        setReceitas.fillAlpha = 65/255.0
        setReceitas.drawCircleHoleEnabled = false
        
        setDespesas.axisDependency = .Left;
        setDespesas.setColor(Color.uicolorFromHex(0x1D3347))
        setDespesas.lineWidth = 2.0
        setDespesas.circleRadius = 3.0
        setDespesas.fillAlpha = 65/255.0
        setDespesas.drawCircleHoleEnabled = false
        
        
        if(!drawChartLoaded){
            lineChartData.setValueFont(UIFont(name: "Futura", size: 10.0))
            
            drawChartLoaded = true
        }
    }
    
    private func setPieChart(months: [String], values: [Double], pieChart:PieChartView) {
        
        var dataEntries:[ChartDataEntry] = []
        for (i,value) in values.enumerate() {
            dataEntries.append(ChartDataEntry(value: value, xIndex: i))
        }
        
        let dataSet = PieChartDataSet(yVals: dataEntries, label: "Balanço")
        let data = PieChartData(xVals: months, dataSet: dataSet)
        
        var colors: [UIColor] = []
        for _ in 0..<months.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        dataSet.colors = colors
        
        data.setValueFont(UIFont(name: "Futura", size: 10.0))
        
        pieChart.descriptionText = ""
        pieChart.legend.enabled = false
        pieChart.data = data
    }

    override func viewWillAppear(animated: Bool) {
//        self.viewDidLoad()
        initDashboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
