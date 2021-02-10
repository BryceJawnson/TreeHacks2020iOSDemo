//
//  ViewController.swift
//  TreeHacks iOS Tutorial
//
//  Created by Bryce Johnson on M/DD/YY.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var motivationQuotes: UITextView!
    @IBOutlet weak var stocksButton: UIButton!
    @IBOutlet weak var newsButton: UIButton!
    private var newsArticleURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the navigation controller (the bar at the top) to have a specific color, title, and tint.
        if let navController = self.navigationController {
            navController.navigationBar.barTintColor = UIColor.green
            navController.navigationBar.tintColor = UIColor.white
            self.title = "WallStreetBets"
        }
        
        image.image = UIImage(named: "moneybag")
        formatStonkButton()
        setupQuote()
        setupNews()
    }
    
    // Formats Button
    private func formatStonkButton() {
        stocksButton.layer.cornerRadius = 5
        stocksButton.layer.borderWidth = 1
        stocksButton.backgroundColor = UIColor.green
        stocksButton.setTitle("To the stonks", for: .normal)
        stocksButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    // Load a quote using the URLSession framework to get data returned from Quotes API
    private func setupQuote() {
        guard let url = URL(string: "https://quotes.rest/qod.json") else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {(data, reponse, error) in
            do {
                // Parse the JSON by accessing multiple levels of dictionaries to get the quote and author
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    guard let quotes = (jsonResult["contents"] as? [String: Any])?["quotes"] as? [Any],
                        let firstQuote = quotes[0] as? [String: Any],
                        let quoteText = firstQuote["quote"] as? String,
                        let quoteAuthor = firstQuote["author"] as? String else { return }

                    // Change the text view to display quote on the main thread
                    DispatchQueue.main.async {
                        self.motivationQuotes.text = "\(quoteText)\n\n- \(quoteAuthor)"
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }

    // Display a button that links to and displays the title of the top NYTimes article by calling the NYTimes API
    private func setupNews() {
        guard let url = URL(string: "https://api.nytimes.com/svc/topstories/v2/home.json?api-key=LlfhUcI1J5lwXvFGVjf4Z1GkZFGl475f") else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {(data, reponse, error) in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    guard let topArticle = (jsonResult["results"] as? [[String: Any]])?[0],
                        let articleTitle = topArticle["title"] as? String,
                        let url = topArticle["url"] as? String else { return }
                    self.newsArticleURL = url
                    DispatchQueue.main.async {
                        self.newsButton.setTitle(articleTitle, for: .normal)
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }

    // Open the url every time the button is tapped
    @IBAction private func buttonTapped(_ sender: UIButton) {
        if let urlString = newsArticleURL, let url = URL(string: urlString) {
            UIApplication.shared.openURL(url)
        }
    }
}

