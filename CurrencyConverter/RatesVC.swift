//
//  RatesVC.swift
//  CurrencyConverter
//
//  Created by Türker Berk Topçu on 21.01.2023.
//

import UIKit

class RatesVC: UIViewController {
    
    var pickerData = [Currency]()
    var baseCurrency: Currency?
    
    @IBOutlet weak var baseLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let base = baseCurrency?.name{
                baseLabel.text = base
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calcRates()

    }
    
    func calcRates(){
        for currency in self.pickerData{
            if let currentRate = currency.value {
                currency.value = (1/(self.baseCurrency?.value)!) * currentRate
            }
        }
        self.tableView.reloadData()
    }

}



extension RatesVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pickerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        if let name = self.pickerData[indexPath.row].name{
            if let rate = self.pickerData[indexPath.row].value{
                var strRate = String(format: "%.4lf", rate)
                
                content.text = "     \(name) : \(strRate)"
                
            }
        }
        else{
            content.text = "NAN"
        }
        cell.contentConfiguration = content
        return cell
        
    }
}
