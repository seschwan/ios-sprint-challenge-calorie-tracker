//
//  CalorieTrackerVC.swift
//  Calorie Tracker
//
//  Created by Seschwan on 9/13/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieTrackerVC: UIViewController {
    
    // MARK: - Variables
    let caloriesController = CaloriesController()
    let dateFormatter = DateFormatter()
    
    // MARK: - Outlets:
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        //caloriesController.loadChart()
        let chart = Chart()
        chart.backgroundColor = .red
       
    }
    
    // MARK: - Methods:
   

    
    // MARK: - Actions:
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        //var calories: Double
        var calorieEntry: UITextField!
        
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Calorie Amount.."
            calorieEntry = textField
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            // Dismisses the alert controller. 
        }))
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
            //TODO add to the table view when the button is pressed.
            guard let calorieEntry = Double(calorieEntry.text!) else { return }
            self.caloriesController.addCalories(calorieCount: calorieEntry)
            self.tableView.reloadData()
            print(self.caloriesController.caloriesArray)
        }))
       
        present(alert, animated: true, completion: nil)
    }

}
// MARK: - Extensions For UITableViewDataSource
extension CalorieTrackerVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return caloriesController.caloriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let calorie = caloriesController.caloriesArray[indexPath.row]
        cell.textLabel?.text = ("Calories: \(calorie.calorieCount)")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        cell.detailTextLabel?.text = dateFormatter.string(from: calorie.timeStamp)
        
        return cell
        
    }
    
    
    
}

