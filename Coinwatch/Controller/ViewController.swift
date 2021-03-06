//
//  ViewController.swift
//  Coinwatch
//
//  Created by Amad Salmon on 21/07/2020.
//  Copyright © 2020 Amad Salmon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate {
    
    var coinManager = CoinManager()
    
    @IBOutlet weak var cryptoAmountLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var updateTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        coinManager.delegate = self
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        cryptoAmountLabel.text = "---.-----"
        currencyNameLabel.text = "   "
        updateTimeLabel.text = "Choose a currency."
    }
    
    
}

//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        print("pickerView.didSelectRow -> \(selectedCurrency)")
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate{
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel) {
        cryptoAmountLabel.text = coin.rateString
        currencyNameLabel.text = coin.asset_id_quote
        self.updateTimeLabel.text = "On \(coin.date) at \(coin.time) UTC."
        print("didUpdateCoin...")
    }
    
    func didFailWithError(error: Error) {
        print("didFailWithError: ")
        print(error)
        DispatchQueue.main.async {
            self.cryptoAmountLabel.text = "---.-----"
            self.currencyNameLabel.text = "N/A"
            self.updateTimeLabel.text = "Currency not available at the moment."
        }
        print("didFailWithError -> updated UI though")
    }
    
    
}
