//
//  AccountDetailController.swift
//  Moneybox light (MN)
//
//  Created by Michalis Neophytou on 08/11/2019.
//  Copyright © 2019 Michalis Neophytou. All rights reserved.
//

import UIKit

class AccountDetailController: UIViewController {
    
    //MARK: Class variables
    var delegate : detailToOverviewProtocol?
    var productResponseObject : ProductResponse?
    
    //MARK: UI Outlets and Actions
    @IBOutlet weak var backBarButton : UIBarButtonItem!
    @IBOutlet weak var addAmountbutton : UIButton!
    @IBOutlet weak var backgroundView : UIView!
    @IBOutlet weak var accountTitleLabel : UILabel!
    @IBOutlet weak var planValueLabel : UILabel!
    @IBOutlet weak var moneyboxLabel : UILabel!
    @IBAction func addPressed(_ sender: UIButton){
        let amountToBeAdded = productResponseObject!.Personalisation.QuickAddDeposit.Amount
        let investorProductId = productResponseObject!.Id
        let token = self.delegate!.getToken()           //grabbing token from parent view through the detailToOverviewProtocol
        
        let parameters = ["Amount": String(amountToBeAdded), "InvestorProductId": String(investorProductId)] as Dictionary<String, String>
                postOneOffPayment(token: token, parameters: parameters, loginCompletionHander: {
                    (returnedNewAmount, response, error) in
                    if let httpURLresponse = response as? HTTPURLResponse{
                        if httpURLresponse.statusCode == 200{       //check if POST was successful
                            DispatchQueue.main.async {
                                self.productResponseObject!.Moneybox = returnedNewAmount!.Moneybox    //update the data source of this detail View
                                self.moneyboxLabel.text = "Moneybox: £" + String(self.productResponseObject?.Moneybox ?? 0)     //update the detail view
                                self.delegate?.oneOffPaymentComplete(investorProductID: investorProductId, newAmount: returnedNewAmount!.Moneybox)     //update the parent view
                                let successAlert = UIAlertController(title: "Quick Deposit Successful", message: "Moneybox ammount is now: £" + String(self.productResponseObject!.Moneybox), preferredStyle: UIAlertController.Style.alert)
                                successAlert.addAction(UIAlertAction(title: "Wonderful!", style: UIAlertAction.Style.default, handler: nil))
                                self.present(successAlert, animated: true, completion: nil)
                            }
                        }else {
                            let failAlert = UIAlertController(title: "Quick Deposit Unsuccessful", message: "Moneybox ammount is unchanged at: £" + String(self.productResponseObject!.Moneybox), preferredStyle: UIAlertController.Style.alert)
                            failAlert.addAction(UIAlertAction(title: "Connection issue", style: UIAlertAction.Style.default, handler: nil))
                            self.present(failAlert, animated: true, completion: nil)
                        }
                    }
            })
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountTitleLabel.text = productResponseObject?.Product.FriendlyName ?? "NA Account"
        planValueLabel.text = "Plan Value: £" + String(productResponseObject?.PlanValue ?? 0 )
        moneyboxLabel.text = "Moneybox: £" + String(productResponseObject?.Moneybox ?? 0)
        addAmountbutton.setTitle("Add: £" + String(productResponseObject?.Personalisation.QuickAddDeposit.Amount ?? 0), for: .normal)
        
        let primeColor = hexStringToUIColor(hex: productResponseObject!.Product.ProductHexCode)
        addAmountbutton.backgroundColor = primeColor
        backgroundView.backgroundColor = primeColor.withAlphaComponent(0.2)
        backBarButton.tintColor = primeColor
        accountTitleLabel.textColor = primeColor
    }
}
