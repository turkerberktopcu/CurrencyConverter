//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Türker Berk Topçu on 19.01.2023.
//

import UIKit


class ViewController: UIViewController{
  
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    var defaultCurrency: Int? = nil
    var selectedCurrency: Currency?
    var pickerData = [Currency]()
    var originalExchangeRates = [Currency]()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRates()
        
        
        if(pickerView == nil){
            print("Error!")
        }
        else{
            pickerView.delegate = self
            pickerView.dataSource = self
                    
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
            if currency.name == "USD"{
                self.defaultCurrency = self.pickerData.count
            }
            self.pickerData.append(currency)
        }
        self.originalExchangeRates = self.pickerData
        self.pickerView.reloadAllComponents()

        if let defaultCurrency = self.defaultCurrency {
            self.pickerView.selectRow(defaultCurrency, inComponent: 0, animated: true)
        
        }
    }
    
    
    @IBAction func seeRatesClicked(_ sender: Any) {
        performSegue(withIdentifier: "toRatesVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRatesVC" {
            let destination = segue.destination as! RatesVC
            destination.pickerData = self.originalExchangeRates
            let selectedRow = self.pickerView.selectedRow(inComponent: 0)
            destination.baseCurrency = self.pickerData[selectedRow]
            if let val = self.pickerData[selectedRow].value {
                print(val)
            }
        }
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


