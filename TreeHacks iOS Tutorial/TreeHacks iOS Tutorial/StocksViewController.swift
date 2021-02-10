//
//  StocksViewController.swift
//  TreeHacks iOS Tutorial
//
//  Created by Bryce Johnson on 2/9/21.
//

import UIKit

class StocksViewController: UIViewController {
    
    @IBOutlet weak var stockInput: UITextField!
    @IBOutlet weak var stockInformation: UITextView!
    @IBOutlet weak var stockEnteredButton: UIButton!
    private var stockSymbol: String?
    private var stockPriceText: String = ""
    private var stockChangeText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formatStonkButton()
    }

    // Formats Enter Button
    private func formatStonkButton() {
        stockEnteredButton.layer.cornerRadius = 5
        stockEnteredButton.layer.borderWidth = 1
        stockEnteredButton.backgroundColor = UIColor.green
        stockEnteredButton.setTitle("Search", for: .normal)
        stockEnteredButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    // Uses alphavantage API to return information on a specific stock
    private func searchStock() {
        guard let url = URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=" + stockSymbol! + "&apikey=SIKKSH5DSJF5PN31") else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {(data, reponse, error) in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
                    let stockResults = jsonResult["Global Quote"] as? [String: Any] {
                    
                    self.stockPriceText = stockResults["05. price"] as! String
                    self.stockChangeText = stockResults["10. change percent"] as! String

                    DispatchQueue.main.async {
                        self.stockInformation.text = "Current Price: $" + self.stockPriceText + " \n " + " Percent Change " + self.stockChangeText
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    // Search for a specified stock
    @IBAction func stockEntered(_ sender: Any) {
        stockSymbol = stockInput.text
        searchStock()
    }
}
