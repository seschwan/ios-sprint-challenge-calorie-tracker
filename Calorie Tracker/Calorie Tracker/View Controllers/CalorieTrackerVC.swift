//
//  CalorieTrackerVC.swift
//  Calorie Tracker
//
//  Created by Seschwan on 9/13/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import UIKit

class CalorieTrackerVC: UIViewController {
    
    // MARK: - Outlets:
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    
    // MARK: - Actions:
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            // Dismisses the alert controller. 
        }))
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
            //TODO add to the table view when the button is pressed.
        }))
        alert.addTextField { (textField) in
            textField.placeholder = "Calorie Amount.."
            // TODO Get the text and do something with it.
        }
        present(alert, animated: true, completion: nil)
    }
    

}
// MARK: - Extensions For UITableViewDataSource
extension CalorieTrackerVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        
        return cell
        
    }
    
    
    
}

