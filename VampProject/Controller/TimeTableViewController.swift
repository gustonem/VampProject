//
//  TimeTableViewController.swift
//  VampProject
//
//  Created by Gusto Nemec on 16/04/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import UIKit

//var items = [Ucebna]()
//var myIndex = 0

class TimeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var timeTableView: UITableView!
    var items = [Ucebna]()
//
//
    var myIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        timeTableView.delegate = self
        timeTableView.dataSource = self
        makeGetCall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timeTableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = items[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //myIndex = indexPath.row
        myIndex = indexPath.row
        performSegue(withIdentifier: "roomToDays", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let daysController = segue.destination as! DaysTableViewController
        daysController.days = items[myIndex].days.filter({!$0.predmety.isEmpty })
    }
    
    func makeGetCall() {
        // Set up the URL request
        let webPage: String = "http://dumo.cz/test/vamp2018prednasky.json"
        guard let url = URL(string: webPage) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let timeTable = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: [String : Any]] else {
                        print("error trying to convert data to JSON")
                        return
                }
                
                for miestnost in timeTable["miestnosti"]! {
                    let item = Ucebna(name: miestnost.key, value: miestnost.value as! [String : Any])
                    if item.name != "" {
                        self.items.append(item)
                    }
                    
                    
                    DispatchQueue.main.async {
                        self.items.sort(by: {$0.name < $1.name})
                        self.timeTableView.reloadData()
                    }
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
