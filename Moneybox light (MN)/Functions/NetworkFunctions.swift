import Foundation


func postLogInObject(parameters: Dictionary<String, String>, loginCompletionHander: @escaping (logInObject?,URLResponse?, Error?) -> Void){
            
    var request = URLRequest(url: URL(string: "https://api-test01.moneyboxapp.com/users/login")!)
    request.httpMethod = "POST"
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
    request.addValue("3a97b932a9d449c981b595", forHTTPHeaderField: "AppId")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("5.10.0", forHTTPHeaderField: "appVersion")
    request.addValue("3.0.0", forHTTPHeaderField: "apiVersion")

    let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
        guard let data = data else {return}
        do {
            if let decodedData = try JSONDecoder().decode(logInObject?.self, from: data){
                loginCompletionHander(decodedData,response, nil)
            }
        } catch let parsingError {
            print("Error", parsingError)
            DispatchQueue.main.async {
                loginCompletionHander(nil,response, parsingError)

            }
        }
    })
    task.resume()
}


func getInvestorProductsObject(token: String, loginCompletionHander: @escaping (investorProductsObject?, URLResponse?, Error?) -> Void){
            
    var request = URLRequest(url: URL(string: "https://api-test01.moneyboxapp.com/investorproducts")!)
    request.httpMethod = "GET"
    request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
    request.addValue("3a97b932a9d449c981b595", forHTTPHeaderField: "AppId")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("5.10.0", forHTTPHeaderField: "appVersion")
    request.addValue("3.0.0", forHTTPHeaderField: "apiVersion")

    let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
        guard let data = data else {return}
        do {
            if let decodedData = try JSONDecoder().decode(investorProductsObject?.self, from: data){
                DispatchQueue.main.async {
                    loginCompletionHander(decodedData, response, nil)
                }
            }
        } catch let parsingError {
            print("Error", parsingError)
            loginCompletionHander(nil,response, parsingError)
        }
    })
    task.resume()
}


func postOneOffPayment(token : String, parameters: Dictionary<String, String>, loginCompletionHander: @escaping (oneOffPaymentObject?,URLResponse?, Error?) -> Void){
            
    var request = URLRequest(url: URL(string: "https://api-test01.moneyboxapp.com//oneoffpayments")!)
    request.httpMethod = "POST"
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
    request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
    request.addValue("3a97b932a9d449c981b595", forHTTPHeaderField: "AppId")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("5.10.0", forHTTPHeaderField: "appVersion")
    request.addValue("3.0.0", forHTTPHeaderField: "apiVersion")

    let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
        guard let data = data else {return}
        do {
            if let decodedData = try JSONDecoder().decode(oneOffPaymentObject?.self, from: data){
                loginCompletionHander(decodedData,response, nil)
            }
        } catch let parsingError {
            print("Error", parsingError)
            DispatchQueue.main.async {
                loginCompletionHander(nil,response, parsingError)

            }
        }
    })
    task.resume()
}
