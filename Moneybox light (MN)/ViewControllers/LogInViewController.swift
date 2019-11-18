//
//  LogInViewController.swift
//  Moneybox light (MN)
//
//  Created by Michalis Neophytou on 08/11/2019.
//  Copyright © 2019 Michalis Neophytou. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    //MARK: Class variables
    var logInObject : logInObject?
    var individualAccountObject : investorProductsObject?

    //MARK: UI Outlets and Actions
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // remember me functinality when toggle is pressed
    @IBAction func switchChanged(_ sender: UISwitch) {
        if rememberSwitch.isOn{
            UserDefaults.standard.set(emailField.text, forKey: "SavedEmail")
            UserDefaults.standard.set(passwordField.text, forKey: "SavedPassword")
            UserDefaults.standard.set(nameField.text, forKey: "SavedName")
        }else{
            emailField.text = ""
            passwordField.text = ""
            nameField.text = ""
            UserDefaults.standard.set(nil, forKey: "SavedEmail")
            UserDefaults.standard.set(nil, forKey: "SavedPassword")
            UserDefaults.standard.set(nil, forKey: "SavedName")
        }
    }

    @IBAction func LoginButtonPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        if rememberSwitch.isOn{
            UserDefaults.standard.set(emailField.text, forKey: "SavedEmail")
            UserDefaults.standard.set(passwordField.text, forKey: "SavedPassword")
            UserDefaults.standard.set(nameField.text, forKey: "SavedName")
        } else {
            UserDefaults.standard.set(nil, forKey: "SavedEmail")
            UserDefaults.standard.set(nil, forKey: "SavedPassword")
            UserDefaults.standard.set(nil, forKey: "SavedName")
        }
        
        if emailField.text == ""{
            let emailAlert = UIAlertController(title: "Error", message: "Please enter your email address.", preferredStyle: UIAlertController.Style.alert)
            emailAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(emailAlert, animated: true, completion: nil)
            activityIndicator.stopAnimating()
        } else if passwordField.text == "" {
            let passwordAlert = UIAlertController(title: "Error", message: "Please enter your password.", preferredStyle: UIAlertController.Style.alert)
            passwordAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(passwordAlert, animated: true, completion: nil)
            activityIndicator.stopAnimating()
        } else {
            
            //MARK: Post Login procedure
            let credentials = ["Email": emailField.text ?? "", "Password": passwordField.text ?? "", "Idfa":  nameField.text ?? ""] as Dictionary<String, String>
            postLogInObject(parameters: credentials, loginCompletionHander: {
                returnedLogInObject, response, error in
                  if let httpURLresponse = response as? HTTPURLResponse{
                    switch httpURLresponse.statusCode {
                    case 200:
                        self.logInObject = returnedLogInObject
                        //MARK: Get Investor Products prodecure
                        getInvestorProductsObject(token: returnedLogInObject!.Session.BearerToken) { (ipObject, ipResponse, ipError) in
                                if let ipObject = ipObject{
                                    self.individualAccountObject = ipObject
                                    DispatchQueue.main.async {
                                        self.performSegue(withIdentifier: "showAccountsSegue", sender: self)
                                    }
                                }
                            }
                    case 401:
                        let authorizationAlert = UIAlertController(title: "Autorization Error", message: "Please enter valid log in credentials", preferredStyle: UIAlertController.Style.alert)
                        authorizationAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(authorizationAlert, animated: true, completion: nil)
                    case 404:
                        let passwordAlert = UIAlertController(title: "Connection Error", message: "Please check your connection to the internet", preferredStyle: UIAlertController.Style.alert)
                        passwordAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(passwordAlert, animated: true, completion: nil)
                    default:
                        let unexpectedAlert = UIAlertController(title: "Unexpected Error", message: "Please try again later", preferredStyle: UIAlertController.Style.alert)
                        unexpectedAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(unexpectedAlert, animated: true, completion: nil)
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
        
        //remember log in credentials functionality
        if UserDefaults.standard.value(forKey: "SavedEmail") != nil {
            rememberSwitch.setOn(true, animated: false)
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
        
        //providing all data that the main account view will need
        accountViewController.loginObject = self.logInObject
        accountViewController.investorAccountObject = self.individualAccountObject
        accountViewController.credentials = ["Email": emailField.text ?? "", "Password": passwordField.text ?? "", "Idfa":  nameField.text ?? ""] as Dictionary<String, String>
    }
}
