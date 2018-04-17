//
//  TimeTableViewController.swift
//  VampProject
//
//  Created by Gusto Nemec on 16/04/2018.
//  Copyright © 2018 Gusto Nemec. All rights reserved.
//

import UIKit


class TimeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var timeTableView: UITableView!
    var items = [Room]()
    
    var filteredRooms = [Room]()
    var shouldShowSearchResults = false

    
    var myIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        makeGetCall()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let index = self.timeTableView.indexPathForSelectedRow{
            self.timeTableView.deselectRow(at: index, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredRooms.count
        } else {
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timeTableView.dequeueReusableCell(withIdentifier: "cell")
        
        if shouldShowSearchResults {
            cell?.textLabel?.text = filteredRooms[indexPath.row].name
        } else {
            cell?.textLabel?.text = items[indexPath.row].name
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "roomToDays", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let daysController = segue.destination as! DaysTableViewController
        if shouldShowSearchResults {
            daysController.days = filteredRooms[myIndex].days.filter({!$0.subjects.isEmpty }).sorted(by: { $0.nameIndex < $1.nameIndex})
        } else {
            daysController.days = items[myIndex].days.filter({!$0.subjects.isEmpty }).sorted(by: { $0.nameIndex < $1.nameIndex})
        }
        
        
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
                    let item = Room(name: miestnost.key, value: miestnost.value as! [String : Any])
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.timeTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredRooms = items.filter({ (names) -> Bool in
            return names.name.lowercased().range(of: searchText.lowercased()) != nil
            })
        
        if searchText != "" {
            shouldShowSearchResults = true
        } else {
            shouldShowSearchResults = false
        }
        self.timeTableView.reloadData()
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
