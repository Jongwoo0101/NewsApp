//
//  ViewController.swift
//  SentiTable
//
//  Created by 원종우 on 2023/04/11.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var TableViewMain: UITableView!
        
        var newsData :Array<Dictionary<String, Any>>?
        func getNews() {
            let task = URLSession.shared.dataTask(with: URL(string: "https://newsapi.org/v2/everything?q=tesla&from=2023-03-14&sortBy=publishedAt&apiKey=676b43f2c15a47f2aadabfd20ba49738")!) { (data, response, error) in
                
                if let dataJson = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: dataJson, options: []) as! Dictionary<String, Any>
                 
                        //Dictionary
                        let articles = json["articles"] as! Array<Dictionary<String, Any>>
                        self.newsData = articles
                        
                        DispatchQueue.main.async {
                            self.TableViewMain.reloadData() //Main
                        }
                       

                    }
                    catch {}
                }
               
            }
            
            task.resume()
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if let news = newsData {
                return news.count
            }
            else {
                 return 0
            }
           
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = TableViewMain.dequeueReusableCell(withIdentifier: "Type1", for: indexPath) as! Type1
            
            
            let idx = indexPath.row
            print("idx :: \(idx)")
            if let news = newsData {
                
                let row = news[idx]
                print("row :: \(row)")
                if let r = row as? Dictionary<String, Any> {
                    print("TITLE :: \(r)")
                    if let title = r["title"] as? String {
                        cell.LabelText.text = title
                    }
                    
                }
                
            }
            
            
            return cell
            
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("CLICK !!! \(indexPath.row)")
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(identifier: "NewsDetailController") as! NewsDetailController
            
            if let news = newsData {
                let row = news[indexPath.row]
                print("row :: \(row)")
                if let r = row as? Dictionary<String, Any> {
                  
                    if let imageUrl = r["urlToImage"] as? String {
                        controller.imageUrl = imageUrl
                    }
                    if let desc = r["description"] as? String {
                        controller.desc = desc
                    }
                }
            }
            showDetailViewController(controller, sender: nil)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let id = segue.identifier, "NewsDetail" == id {
                if let controller = segue.destination as? NewsDetailController {
                    
                    if let news = newsData {
                        if let indexPath = TableViewMain.indexPathForSelectedRow {
                            let row = news[indexPath.row]
                            print("row :: \(row)")
                            if let r = row as? Dictionary<String, Any> {
                              
                                if let imageUrl = r["urlToImage"] as? String {
                                    controller.imageUrl = imageUrl
                                }
                                if let desc = r["description"] as? String {
                                    controller.desc = desc
                                }
                            }
                        }
                        
                        
                    }
                }
            }
            
            
        }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            TableViewMain.delegate = self
            TableViewMain.dataSource = self
            
            getNews()
        }
    
}
