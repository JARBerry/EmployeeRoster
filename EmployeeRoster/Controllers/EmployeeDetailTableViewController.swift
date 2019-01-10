//
//  EmployeeDetailTableViewController.swift
//  EmployeeRoster
//
//  Created by James and Ray Berry on 19/12/2018.
//


import UIKit

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate, EmployeeTypeDelegate{
    
    
    func didSelect(employeeType: EmployeeType) {
        self.employeeType = employeeType
         employeeTypeLabel.textColor = .black
        updateEmployeeType()
    }
    

    struct PropertyKeys {
        static let unwindToListIndentifier = "UnwindToListSegue"
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dobLabel: UILabel!
    
    @IBOutlet weak var dobPicker: UIDatePicker!
    
    @IBOutlet weak var employeeTypeLabel: UILabel!
    
    var employee: Employee?
    
    
    var employeeType : EmployeeType?
    
    var isEditingBirthday: Bool = false {
        didSet {
       ///  dobPicker.isHidden = !isEditingBirthday
        tableView.beginUpdates()
        tableView.endUpdates()
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        
        
        // Setting the maximum date possible and the one displayed.
        let midnightToday = Calendar.current.startOfDay(for: Date())
        dobPicker.maximumDate = midnightToday
        
        if dobLabel.text == nil {
            dobPicker.date = midnightToday
        } else {
            dobPicker.date = setDatePickerFromString(date: dobLabel.text!)
        }
        
    }
    
    // update employee information
    func updateView() {
        if let employee = employee {
            navigationItem.title = employee.name
            nameTextField.text = employee.name
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dobLabel.text = dateFormatter.string(from: employee.dateOfBirth)
            dobLabel.textColor = .black
            employeeTypeLabel.text = employee.employeeType.description()
            employeeTypeLabel.textColor = .black
        } else {
            navigationItem.title = "New Employee"
        }
    }
    
    
    // define format of date picker returns a string
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    
    // set date picker returns a date
    func setDatePickerFromString(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let unwrappedDate = dateFormatter.date(from: date)
        guard let date = unwrappedDate else { return Date() }
        return date
    }
    
    
    
    // change height of cell depedning on if date picker is chosen
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        if indexPath.row != 2 {
            return 44.0
        } else {
            if isEditingBirthday  {
                return 216.0
            } else {
                return 0.0
            }
        }
        
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            isEditingBirthday = !isEditingBirthday
            dobLabel.textColor = UIColor.black

            // Set the date to the label.
            dobLabel.text = formatDate(date: dobPicker.date)
            
          
        }
        
    }
    
  
    // if save button tapped update details
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let name = nameTextField.text,
            let employeeTypeSelected = employeeType {
            employee = Employee(name: name, dateOfBirth: dobPicker.date, employeeType: employeeTypeSelected)
            performSegue(withIdentifier: PropertyKeys.unwindToListIndentifier, sender: self)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        employee = nil
        performSegue(withIdentifier: PropertyKeys.unwindToListIndentifier, sender: self)
    }
    
    
    // if date selected call date picker
    
    @IBAction func dobDatePickerAction(_ sender: UIDatePicker) {
        
      dobLabel.text = formatDate(date: sender.date)
    }
    
    
    
    // prepare for segue to select employee type from list
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmployeeTypeSegue" {
            
            let destinationViewController = segue.destination as?
            EmployeeTypeTableViewController
            destinationViewController?.delegate = self
            destinationViewController?.employeeType = employeeType
            
        }
    }
    
    
    
    
    // MARK: - Text Field Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func updateEmployeeType() {
        if let employeeType = employeeType {
            employeeTypeLabel.text = employeeType.description()
            
        } else {
            employeeTypeLabel.text = "Not Set"
        }
    }
   

}
