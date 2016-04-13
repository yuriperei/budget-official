//
//  DashboardViewController.swift
//  Budget
//
//  Created by md10 on 3/18/16.
//  Copyright © 2016 Budget. All rights reserved.
//

import UIKit
import Charts

class DashboardViewController: UIViewController, ChartViewDelegate {
    
    var colors = [UIColor]()
    @IBOutlet weak var lblBalancoTotal: UILabel!
    @IBOutlet weak var lblTotalDespesas: UILabel!
    @IBOutlet weak var lblTotalReceitas: UILabel!
    @IBOutlet var btnMenuSidebar: UIBarButtonItem!
    @IBOutlet var lineChartBalanco: LineChartView!
    @IBOutlet var pieChartDespesas: PieChartView!
    @IBOutlet var pieChartReceitas: PieChartView!
    @IBOutlet var graphReader: GraphReaderView!
    
    let dashboard:Dashboard = Dashboard()
    //var drawChartLoaded:Bool = false
    
    // MARK: - Functions generated
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineChartBalanco.delegate = self
        
        drawLineChartBalanco()
        SidebarMenu.configMenu(self, sideBarMenu: btnMenuSidebar)
    }

    override func viewWillAppear(animated: Bool) {
        initDashboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Delegate methods
    
    // Função utilizada para adicionar uma view flutuante apresentando os valores do lineChartBalanco
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        
        let markerPosition = chartView.getMarkerPosition(entry: entry,  highlight: highlight)
        
        graphReader.valueLabel.text = "\(entry.value.roundDecimal(2))"
        graphReader.dateLabel.text = "\(chartView.getXValue(entry.xIndex))"
        graphReader.center = CGPointMake(markerPosition.x + 30, lineChartBalanco.frame.origin.y + 200)
        
        graphReader.hidden = false
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        graphReader.hidden = true
    }
    
    // MARK: - Private functions
    
    private func initDashboard() {
        
        //Carregando as labels
        lblBalancoTotal.text = dashboard.getSaldoTotal().convertToCurrency("pt_BR")
        lblTotalReceitas.text = dashboard.getTotalReceitas().convertToCurrency("pt_BR")
        lblTotalDespesas.text = dashboard.getTotalDespesas().convertToCurrency("pt_BR")
        
        // Carregando os gráficos
        let (months, receitasMensal, despesasMensal) = dashboard.getBalancoAnual()
        let (despesas, valorDespesas) = dashboard.getDespesasPorCategoria()
        let (receitas, valorReceitas) = dashboard.getReceitasPorCategoria()
        
        setLineBalanco(months, receitas: receitasMensal, despesas: despesasMensal)
        
        if(valorDespesas.count > 0) {
            pieChartDespesas.hidden = false
            setPieChart(despesas, values: valorDespesas, pieChart: pieChartDespesas)
        } else {
            pieChartDespesas.hidden = true
        }
        
        if(valorReceitas.count > 0) {
            pieChartReceitas.hidden = false
            setPieChart(receitas, values: valorReceitas, pieChart: pieChartReceitas)
        } else {
            pieChartReceitas.hidden = true
        }
    }
    
    private func drawLineChartBalanco() {
        
        let xAxis = lineChartBalanco.xAxis
        xAxis.labelPosition = .Bottom
        xAxis.drawGridLinesEnabled = false
        
        lineChartBalanco.leftAxis.enabled = false
        lineChartBalanco.rightAxis.enabled = false
        lineChartBalanco.descriptionTextPosition = CGPointMake(lineChartBalanco.frame.origin.x + 80, lineChartBalanco.frame.origin.y)
        lineChartBalanco.descriptionText = ""
        lineChartBalanco.legend.enabled = false
    }
    
    private func setLineBalanco(months: [String], receitas: [Double], despesas: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        var dataEntries2: [ChartDataEntry] = []
        
        for i in 0..<months.count {
            dataEntries.append(ChartDataEntry(value: receitas[i], xIndex: i))
            dataEntries2.append(ChartDataEntry(value: despesas[i], xIndex: i))
        }
        
        let setReceitas = LineChartDataSet(yVals: dataEntries, label: "Receitas")
        let setDespesas = LineChartDataSet(yVals: dataEntries2, label: "Despesas")
        let lineChartData = LineChartData(xVals: months, dataSets: [setReceitas, setDespesas])
        lineChartData.setValueFont(UIFont(name: "Futura", size: 10.0))
        
        lineChartBalanco.data = lineChartData
        
        setReceitas.axisDependency = .Left;
        setReceitas.circleColors = [Color.uicolorFromHex(0x467BAD)]
        setReceitas.circleRadius = 5.0
        setReceitas.drawValuesEnabled = false
        setReceitas.lineWidth = 3.0
        setReceitas.setColor(Color.uicolorFromHex(0x467BAD))
        
        setDespesas.axisDependency = .Left;
        setDespesas.circleColors = [Color.uicolorFromHex(0x2C4E6E)]
        setDespesas.circleRadius = 5.0
        setDespesas.drawValuesEnabled = false
        setDespesas.lineWidth = 3.0
        setDespesas.setColor(Color.uicolorFromHex(0x1D3347))
    }
    
    private func setPieChart(categorias: [String], values: [Double], pieChart:PieChartView) {
        
        var dataEntries:[ChartDataEntry] = []
        
        for (i,value) in values.enumerate() {
            dataEntries.append(ChartDataEntry(value: value, xIndex: i))
        }
        
        let dataSet = PieChartDataSet(yVals: dataEntries, label: "Balanço")
        let data = PieChartData(xVals: categorias, dataSet: dataSet)
        
        loadColors(categorias.count)
        dataSet.colors = colors
        dataSet.sliceSpace = 2.0;
        
        data.setValueFont(UIFont(name: "Futura", size: 10.0))
        
        pieChart.descriptionText = ""
        pieChart.legend.enabled = false
        pieChart.data = data
    }
    
    private func loadColors(numberOfColors:Int) {
        
        var int = UInt32(0x274561).intValue!
        var int2 = UInt32(0x467BAD).intValue!
        
        for _ in 0..<numberOfColors {           
            int += 15
            int2 += 15
            
            if int % 2 == 0{
                colors.append(Color.uicolorFromHex(UInt32(int)))
            }else{
                colors.append(Color.uicolorFromHex(UInt32(int2)))
            }
            
            
            
        }
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


/*
Comentários temporários
//    var zoom:CGFloat = 0.0

leftAxis.labelPosition = .OutsideChart
leftAxis.spaceTop = 0.15
leftAxis.customAxisMin = 0
leftAxis.labelFont = UIFont(name: "Futura", size: 10.0)!

rightAxis.drawGridLinesEnabled = false
rightAxis.spaceTop = 0.15
rightAxis.customAxisMin = 0
rightAxis.labelFont = leftAxis.labelFont

//pieChartDespesas.noDataText = "Não existem despesas\nregistradas esse mês"
//pieChartReceitas.noDataText = "Não existem receitas\nregistradas esse mês"

//lineChartBalanco.legend.position = .BelowChartLeft
//lineChartBalanco.legend.form = .Square
//lineChartBalanco.legend.formSize = 9.0
//lineChartBalanco.legend.xEntrySpace = 4.0
//xAxis.spaceBetweenLabels = 2
*/
