//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Türker Berk Topçu on 19.01.2023.
//

import UIKit


class ViewController: UIViewController{
  
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var pickerData = [Currency]()
    
    @IBOutlet weak var chooseCurrency: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRates()
        
        if(pickerView == nil){
            print("Error!")
        }
        else{
            pickerView.delegate = self
            pickerView.dataSource = self
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            let view = pickerView.delegate?.pickerView?(pickerView, titleForRow: selectedRow, forComponent: 0) as? UILabel
        }

    }
    
    
    func getRates(){
        
        let url = URL(string: "https://api.freecurrencyapi.com/v1/latest?apikey=4z9HwDBOOk1rT8ykKPhdRq1iNWK51wHhMAqauAaK")
        let session = URLSession.shared
        let task = session.dataTask(with: url! ) { (data, response, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Connection could not be established. ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true)
            }
            else{
                if data != nil {
                    do{
                        let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any?>
                        
                        DispatchQueue.main.async {
                            let rates = jsonResult["data"] as! Dictionary<String, Double>
                            self.addItem(dict: rates)
                            
                            
                        }
                        
                    }
                    catch{
                        
                    }
                }
            }
        }
        task.resume()
            
    }
        
        
    
    
    func addItem(dict: Dictionary<String, Double>) {
        let keys = dict.keys
        
        for key in keys {
            let rate = dict[key]
            let currency = Currency(name: key, value: rate!)
            self.pickerData.append(currency)
        }
        self.pickerView.reloadAllComponents()
        }
    
    
    
}



extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard self.pickerData.count != 0 else {return ""}
        
        return self.pickerData[row].name
        }
    
}


