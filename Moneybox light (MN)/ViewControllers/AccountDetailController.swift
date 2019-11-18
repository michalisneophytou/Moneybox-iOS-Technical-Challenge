//
//  AccountDetailController.swift
//  Moneybox light (MN)
//
//  Created by Michalis Neophytou on 08/11/2019.
//  Copyright © 2019 Michalis Neophytou. All rights reserved.
//

import UIKit

class AccountDetailController: UIViewController {
    
    var delegate : detailToOverviewProtocol?
    var productResponseObject : ProductResponse?
    
    @IBOutlet weak var backBarButton : UIBarButtonItem!
    @IBOutlet weak var addAmountbutton : UIButton!
    @IBOutlet weak var backgroundView : UIView!
    @IBOutlet weak var accountTitleLabel : UILabel!
    @IBOutlet weak var planValueLabel : UILabel!
    @IBOutlet weak var moneyboxLabel : UILabel!
    
    @IBAction func addPressed(_ sender: UIButton){
        let amountToBeAdded = productResponseObject!.Personalisation.QuickAddDeposit.Amount
        let investorProductId = productResponseObject!.Id
        let token = self.delegate!.getToken()
        let parameters = ["Amount": String(amountToBeAdded), "InvestorProductId": String(investorProductId)] as Dictionary<String, String>
                postOneOffPayment(token: token, parameters: parameters, loginCompletionHander: {
                    (returnedNewAmount, response, error) in
                    if let newAmount = returnedNewAmount{
                        DispatchQueue.main.async {
                            self.productResponseObject!.Moneybox = newAmount.Moneybox
                            self.moneyboxLabel.text = "Moneybox: £" + String(self.productResponseObject?.Moneybox ?? 0)
                            self.delegate?.oneOffPaymentComplete(investorProductID: investorProductId, newAmount: newAmount.Moneybox)
                            let alert = UIAlertController(title: "Quick Deposit Successful", message: "Moneybox ammount is now: £" + String(newAmount.Moneybox), preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Wonderful!", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
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
