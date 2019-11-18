//
//  AccountViewController.swift
//  Moneybox light (MN)
//
//  Created by Michalis Neophytou on 08/11/2019.
//  Copyright © 2019 Michalis Neophytou. All rights reserved.
//

import UIKit
import Charts

class AccountViewController: UIViewController {
    
    //MARK: Class variables
    var loginObject : logInObject?
    var investorAccountObject : investorProductsObject?
    var credentials : Dictionary<String, String>?
    var pieChartHighlighted : Double?
    
    //MARK: UI Outlets and Actions
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var helloUserLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBAction func signOutButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        pieChartView.delegate = self

        self.tableView.register(AccountCell.self, forCellReuseIdentifier: "accountView")
        helloUserLabel.text = "Welcome Back " + (loginObject?.User.FirstName ?? "")
        tableView.reloadData()
        customizeChart()
        
        // to refresh the bearer token every 4.5 minutes
        DispatchQueue.main.asyncAfter(deadline: .now() + 270, execute: {
            self.refreshToken()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationNavigationController = segue.destination as! UINavigationController
        let accountDetailController = destinationNavigationController.topViewController as! AccountDetailController
        accountDetailController.productResponseObject = investorAccountObject!.ProductResponses[sender as! Int] //passing a single product response to each accountDetailController created
        accountDetailController.delegate = self
    }
    
    ///uses the credentials passed just before the segue and gets a new token and refreshes the viewer and its data
    func refreshToken(){
        postLogInObject(parameters: self.credentials!, loginCompletionHander: {
            returnedLogInObject, response, error in
            if let httpURLresponse = response as? HTTPURLResponse{
              switch httpURLresponse.statusCode {
              case 200:
                self.loginObject = returnedLogInObject
                getInvestorProductsObject(token: returnedLogInObject!.Session.BearerToken) { (ipObject, ipResponse, ipError) in
                      if let ipObject = ipObject{
                          self.investorAccountObject = ipObject
                          self.tableView.reloadData()
                          self.customizeChart()
                      }
                  }
              default:
                  let unexpectedAlert = UIAlertController(title: "Unexpected Refresh Error", message: "Please try again later", preferredStyle: UIAlertController.Style.alert)
                  unexpectedAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                  self.present(unexpectedAlert, animated: true, completion: nil)
                  self.dismiss(animated: true, completion: nil)
              }
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 270.0, execute: {
            self.refreshToken()
        })
    }
}

//MARK: TableView functions
extension AccountViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.investorAccountObject?.ProductResponses.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1    //mutiple sections used instead of mutilple cells in each seaction, to add separation between the cells
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10     //table headers were used to add gap between the cells
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // essential to add (clear) gap between the cells
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AccountCell = self.tableView.dequeueReusableCell(withIdentifier: "accountCell") as! AccountCell
        let singleAccount = investorAccountObject?.ProductResponses[indexPath.section]
        cell.accountTextLabel.text = singleAccount?.Product.FriendlyName
        cell.planValueLabel.text = "Plan Value: £" + String(format:"%.2f", singleAccount?.PlanValue ?? 0.0)
        cell.moneyboxLabel.text = "Moneybox: £" + String(singleAccount?.Moneybox ?? 0)
        
        // so that the right cell is empasised when a pie chart segment is tapped/
        if singleAccount?.PlanValue == pieChartHighlighted ?? 0.00000000001{
            cell.contentView.layer.borderWidth = 4
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.accountTextLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        } else {
            cell.contentView.layer.borderWidth = 0
            cell.accountTextLabel.font = UIFont.systemFont(ofSize: 18.0)
        }
        let cellColor : UIColor = hexStringToUIColor(hex: singleAccount!.Product.ProductHexCode)
        cell.arrowImage.tintColor = cellColor
        cell.contentView.backgroundColor = cellColor.withAlphaComponent(0.2)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // note that indexPath.section and not indexPath.row as each section has a row and mutiple sections are used
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "showDetailSegue", sender: indexPath.section)    //sender is the index and used to send the right one fo the ProductResponses to the detail view
    }
}

//MARK: Protocol detailToOverviewProtocol functions
//Protocol functions to get the changes that the AccountDetailController does by POST at /oneoffpayments
extension AccountViewController : detailToOverviewProtocol{
    func oneOffPaymentComplete(investorProductID: Int, newAmount: Int) {
        if let row = self.investorAccountObject?.ProductResponses.firstIndex(where: {$0.Id == investorProductID}) {
            var newArrayEntry = self.investorAccountObject?.ProductResponses[row]
            newArrayEntry?.Moneybox = newAmount
            self.investorAccountObject?.ProductResponses[row] = newArrayEntry!
        }
        self.tableView.reloadData()
        customizeChart()
    }
    
    func getToken() -> String {
        return (loginObject?.Session.BearerToken)!
    }
}

extension AccountViewController: ChartViewDelegate{
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        pieChartHighlighted = entry.y
        tableView.reloadData()
    }
    
    /// function to get the Pie Chart formatted and refresh its data
    func customizeChart() {
          var dataEntries: [ChartDataEntry] = []
          let accountTypes = self.investorAccountObject!.ProductResponses.map({ (productResponse: ProductResponse) -> String in
              productResponse.Product.FriendlyName
          })
          let accountValues = self.investorAccountObject!.ProductResponses.map({ (productResponse: ProductResponse) -> Double in
              productResponse.PlanValue
          })
          let accountColors = self.investorAccountObject!.ProductResponses.map({ (productResponse: ProductResponse) -> UIColor in
              hexStringToUIColor(hex: productResponse.Product.ProductHexCode)
          })
          
          for i in 0..<investorAccountObject!.ProductResponses.count {
          let dataEntry = PieChartDataEntry(value: accountValues[i], label: accountTypes[i], data:  accountTypes[i] as AnyObject)
          dataEntries.append(dataEntry)
          }
        
          let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
          pieChartDataSet.colors = accountColors
          let pieChartData = PieChartData(dataSet: pieChartDataSet)
          
          let format = NumberFormatter()
          format.numberStyle = .percent
          format.multiplier = 1.0
          format.maximumFractionDigits = 1
          format.minimumFractionDigits = 1
          let formatter = DefaultValueFormatter(formatter: format)
          pieChartData.setValueFormatter(formatter)
          pieChartDataSet.yValuePosition = PieChartDataSet.ValuePosition.outsideSlice

          pieChartData.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 12)!)
          pieChartData.setValueTextColor(UIColor.black)
          pieChartView.animate(yAxisDuration: 1, easingOption: .easeInQuart)
          pieChartView.rotationAngle = 50.0
          pieChartView.drawEntryLabelsEnabled = true
          
          let style = NSMutableParagraphStyle()
          style.lineBreakMode = .byWordWrapping
          style.alignment = NSTextAlignment.center
          let centerTitleAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.paragraphStyle: style,             NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Medium", size: 20)!]
          pieChartView.centerAttributedText = NSAttributedString(string: "Total Plan Value: £" + String(investorAccountObject!.TotalPlanValue), attributes: centerTitleAttributes)
          pieChartView.legend.enabled = false
          pieChartView.usePercentValuesEnabled = true
          pieChartView.sizeToFit()
          pieChartView.data = pieChartData
      }
    
}
