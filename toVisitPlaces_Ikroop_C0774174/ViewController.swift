//
//  ViewController.swift
//  toVisitPlaces_Ikroop_C0774174
//
//  Created by VirkIkroop on 2020-06-14.
//  Copyright © 2020 VirkIkroop. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = ["CN Tower", "Toronto eye","canada wonderland","orangevile"]
    
    var places : [Places]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      //  let place = places![indexPath.row]
       // let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        let cell = UITableViewCell()
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
  


}

