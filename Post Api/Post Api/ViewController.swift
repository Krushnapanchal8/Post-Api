//
//  ViewController.swift
//  Post Api
//
//  Created by Mac on 21/06/1943 Saka.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var textTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnPostClick(_ sender: UIButton) {
        self.setupPostMethod()
    }
}
    
extension ViewController{
        func setupPostMethod() {
            
            guard let uid = self.textTF.text else {return}
            guard let title = self.nameTF.text else {return}
            guard let body = self.surnameTF.text else {return}
            
            
            if let url = URL(string: "https://jsonplaceholder.typicode.com/posts") {
               var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                let parameters: [String:Any] = [
                    "userId":uid,
                    "title":title,
                    "body":body
                ]
                
                request.httpBody = parameters.percentEscaped().data(using: .utf8)
                
                
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    guard let data = data  else {
                        if error == nil {
                            print(error?.localizedDescription ?? "Unkown Error")
                        }
                        return
                    }
                    
                    if let response = response as? HTTPURLResponse {
                        guard (200...299) ~= response.statusCode else {
                            print("status code :- \(response.statusCode)")
                            print(response)
                            return
                        }
                    }
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                    } catch {
                        print(error.localizedDescription)
                    }
                }.resume()
            }
        }
    }



    


extension Dictionary {
    func percentEscaped() -> String {
        return map {(key, value) in
            
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            return escapedKey + "=" + escapedValue
    }
        .joined(separator: "&")
  }
}


extension CharacterSet {
    static var urlQueryValueAllowed: CharacterSet {
        
        let generalDelimitersToEncode = ":#[]@"
        
        let subDelimitersToEncode = "!$()*;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return allowed
    }
}
