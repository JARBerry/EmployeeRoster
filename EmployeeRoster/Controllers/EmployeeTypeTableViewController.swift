//
//  EmployeeTypeTableViewController.swift
//  EmployeeRoster
//
//  Created by James and Ray Berry on 19/12/2018.
//


protocol EmployeeTypeDelegate {
    
    func didSelect(employeeType: EmployeeType)
}

import UIKit

class EmployeeTypeTableViewController: UITableViewController {

    var employeeType: EmployeeType?
    
    var delegate: EmployeeTypeDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return EmployeeType.all.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeTypeSelected", for: indexPath)

       
        let type = EmployeeType.all[indexPath.row]
        cell.textLabel?.text = type.description()

        if employeeType == type {
            
            cell.accessoryType = .checkmark
        } else {
            
            cell.accessoryType = .none
            
        }
        
        
        

        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        employeeType = EmployeeType.all[indexPath.row]
        delegate?.didSelect(employeeType: employeeType!)
        tableView.reloadData()
        
        
    }

    

}
