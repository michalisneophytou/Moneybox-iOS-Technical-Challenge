//
//  LogInViewController.swift
//  Moneybox light (MN)
//
//  Created by Michalis Neophytou on 08/11/2019.
//  Copyright © 2019 Michalis Neophytou. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    var logInObject : logInObject?
    var individualAccountObject : investorProductsObject?

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func switchChanged(_ sender: UISwitch) {
        if !(rememberSwitch.isOn){
            emailField.text = ""
            passwordField.text = ""
            nameField.text = ""
            UserDefaults.standard.set("", forKey: "SavedEmail")
            UserDefaults.standard.set("", forKey: "SavedPassword")
            UserDefaults.standard.set("", forKey: "SavedName")
        }
    }

    @IBAction func LoginButtonPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        if rememberSwitch.isOn{
            UserDefaults.standard.set(emailField.text, forKey: "SavedEmail")
            UserDefaults.standard.set(passwordField.text, forKey: "SavedPassword")
            UserDefaults.standard.set(nameField.text, forKey: "SavedName")
        } else {
            UserDefaults.standard.set("", forKey: "SavedEmail")
            UserDefaults.standard.set("", forKey: "SavedPassword")
            UserDefaults.standard.set("", forKey: "SavedName")
        }
        
        if emailField.text == ""{
            let alert = UIAlertController(title: "Error", message: "Please enter your email address.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            activityIndicator.stopAnimating()
        } else if passwordField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Please enter your password.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            activityIndicator.stopAnimating()
        } else {
            let credentials = ["Email": emailField.text ?? "", "Password": passwordField.text ?? "", "Idfa":  nameField.text ?? ""] as Dictionary<String, String>
            postLogInObject(parameters: credentials, loginCompletionHander: {
                returnedLogInObject, response, error in
                  if let newLogInObject = returnedLogInObject{
                    self.logInObject = newLogInObject
                    getInvestorProductsObject(token: newLogInObject.Session.BearerToken) { (ipObject, ipResponse, ipError) in
                            if let ipObject = ipObject{
                                self.individualAccountObject = ipObject
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "showAccountsSegue", sender: self)
                                }
                            }
                        }
                  }
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.stopAnimating()
        if UserDefaults.standard.value(forKey: "SavedEmail") as! String != ""{
            emailField.text = (UserDefaults.standard.value(forKey: "SavedEmail") as! String)
            passwordField.text = (UserDefaults.standard.value(forKey: "SavedPassword") as! String)
            nameField.text = (UserDefaults.standard.value(forKey: "SavedName") as! String)
        } else {
            rememberSwitch.setOn(false, animated: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationNavigationController = segue.destination as! UINavigationController
        let accountViewController = destinationNavigationController.topViewController as! AccountViewController
        accountViewController.loginObject = self.logInObject
        accountViewController.investorAccountObject = self.individualAccountObject
        accountViewController.credentials = ["Email": emailField.text ?? "", "Password": passwordField.text ?? "", "Idfa":  nameField.text ?? ""] as Dictionary<String, String>
    }
}
