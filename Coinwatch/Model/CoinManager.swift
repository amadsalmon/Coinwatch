//
//  CoinManager.swift
//  Coinwatch
//
//  Created by Amad Salmon on 21/07/2020.
//  Copyright © 2020 Amad Salmon. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate"
    let apiKey = "18FA90B6-63A4-4E3F-985F-089ACA0C27A8"
    let crypto = "BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String){
        let fullURL = "\(baseURL)/\(crypto)/\(currency)?apikey=\(apiKey)"
        print(fullURL)
        performRequest(urlString: fullURL)
    }
    
    func performRequest(urlString: String){
        // 1. Create an URL
        if let url = URL(string: urlString){
            // 2. Create an URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    // self.delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
                if let safeData = data {
                    //let dataString = String(data: safeData, encoding: .utf8)
                    //print(dataString!)
                    if let coinModel = self.parseJSON(safeData){
                        /** Long-running tasks such as networking are often executed in the background, and provide a completion handler to signal completion.
                            Attempting to read or update the UI from a completion handler may cause problems.
                            Dispatch the call to update the label text to the main thread.
                         */
                        DispatchQueue.main.async {
                            self.delegate?.didUpdateCoin(self, coin: coinModel)
                        }
                    }
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            
            let time = decodedData.time
            let asset_id_base = decodedData.asset_id_base
            let asset_id_quote = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            let coinModel = CoinModel(time: time, asset_id_base: asset_id_base, asset_id_quote: asset_id_quote, rate: rate)
            
            print("\(asset_id_base) / \(asset_id_quote) = \(rate)")
            
            return coinModel
        }catch{
            print("Error in parseJSON: ")
            print(error)
            print("End of error in parseJSON ---------------- ")
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
