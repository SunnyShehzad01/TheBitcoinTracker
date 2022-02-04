//
//  ViewController.swift
//  TheBitcoinTracker
//
//  Created by Sunny Shehzad on 04/02/22.
//
/*
 "rates": {
     "btc": {
       "name": "Bitcoin",
       "unit": "BTC",
       "value": 1,
       "type": "crypto"
     },
     "eth": {
       "name": "Ether",
       "unit": "ETH",
       "value": 13.367,
       "type": "crypto"
     }
     "eur": {
           "name": "Euro",
           "unit": "€",
           "value": 33105.208,
           "type": "fiat"
         }
     "inr": {
           "name": "Indian Rupee",
           "unit": "₹",
           "value": 2835093.547,
           "type": "fiat"
         }
 }
 */
import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var bitcoinPrice: UILabel!
    @IBOutlet weak var ethPrice: UILabel!
    @IBOutlet weak var euroPrice: UILabel!
    @IBOutlet weak var inrPrice: UILabel!
    @IBOutlet weak var recentlyUpdated: UILabel!
    
    let urlString = "https://api.coingecko.com/api/v3/exchange_rates"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        _ = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true)
    }
    @objc func refreshData() -> Void
        {
            fetchData()
        }
    
    func fetchData() {
        let url = URL(string: urlString)
        let defaultSession = URLSession(configuration: .default)
        let dataTask = defaultSession.dataTask(with: url!) {
                        (data: Data? ,response : URLResponse?,error :  Error?) in
            if(error != nil) {
                print(error!)
                return
            }
            do{
                let json = try JSONDecoder().decode(Rates.self, from: data!)
                self.setPrices(currency: json.rates)
            }
            catch{
                print(error)
                return
            }
        }
        dataTask.resume()
    }
    
    func setPrices(currency: Currency)
        {
            DispatchQueue.main.async
            {
                self.bitcoinPrice.text = self.formatPrices(currency.btc)
                self.ethPrice.text = self.formatPrices(currency.eth)
                self.euroPrice.text = self.formatPrices(currency.eur)
                self.inrPrice.text = self.formatPrices(currency.inr)
                self.recentlyUpdated.text = self.formatDate(date: Date())
            }
        }
    func formatPrices(_ price: Price) -> String {
        return String(format: "%@ %.4f", price.unit, price.value)
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM y HH:mm:ss"
        return formatter.string(from: date)
    }
    
    struct Rates : Codable {
        let rates : Currency
    }
    
    struct Currency : Codable {
        let btc : Price
        let eth : Price
        let eur : Price
        let inr : Price
    }
    
    struct Price : Codable {
        let name : String
        let unit : String
        let value : Float
        let type : String
    }

}

