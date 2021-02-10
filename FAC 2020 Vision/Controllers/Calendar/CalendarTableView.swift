//
//  CalendarTableView.swift
//  FAC 2020 Vision
//
//  Created by Matthew Rempel on 2020-12-04.
//  Copyright © 2020 Foothills Alliance Church. All rights reserved.
//

import Foundation
import UIKit

class CalendarTableView: UITableViewController {
    var years:[String] = []
    var months:[String : [String]] = DateFormater().getMonthsSoFar()
    
    var selectedMonth:String?
    var selectedYear:String?
    var selectedDevotion:Devotion?
    
    // IBOutlets
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        // Get the years and sort them
        years = Array(months.keys).sorted().reversed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Navigation Controller
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    // MARK: UITableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return years.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return months[years[section]]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.textLabel?.font = cell.textLabel?.font.withSize(UIFont.systemFontSize)
        if let title = months[years[indexPath.section]]?[indexPath.row] {
            cell.textLabel?.text = title
        }
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedYear = years[indexPath.section]
        selectedMonth = months[selectedYear!]?[indexPath.row]
        self.performSegue(withIdentifier: "month", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return years[section]
    }
    
    
    // MARK: - IBActions
    @IBAction func sortPressed(_ sender: Any) {
        self.years = self.years.reversed()
        self.tableView.reloadData()
    }
    
    @IBAction func donePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "month") {
            
            let vc = segue.destination as! CalendarDetailTableView
            vc.viewYear = selectedYear
            vc.viewMonth = selectedMonth
            
        }
    }
}
