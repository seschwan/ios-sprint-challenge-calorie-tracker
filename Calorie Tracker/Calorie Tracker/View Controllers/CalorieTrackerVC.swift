//
//  CalorieTrackerVC.swift
//  Calorie Tracker
//
//  Created by Seschwan on 9/13/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieTrackerVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Variables
    let caloriesController = CaloriesController()
    let dateFormatter = DateFormatter()
    
    // Stored Property
    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    
    
    // MARK: - Outlets:
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chartView: Chart!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        chartView.backgroundColor = .clear
        updateChartData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatedCalories(notification:)), name: .updatedCalories, object: nil)
        
    }
    
    // MARK: - Methods:
//    func loadingChart() { // This would be the programatic approach.
//        let chart = Chart(frame: CGRect(x: 0, y: 0, width: chartView.frame.width, height: chartView.frame.height)) // This is how you would get it to work programmatically.
//
//        chart.backgroundColor = .cyan
//        let series = ChartSeries([100, 200, 300, 400])
//        chart.add(series)
//        chartView.addSubview(chart)
//    }
    
    @objc func updatedCalories(notification: NSNotification) {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            NSLog("There was an error with the NSNotification: \(error)")
        }
        updateChartData()
    }
    
    func updateChartData() {
        var data = [Double]()
        if let calorieData = fetchedResultsController.fetchedObjects {
            for calorieCount in calorieData {
                data.append(calorieCount.calorieCount)
            }
        }
        chartView.removeAllSeries()
        let series = ChartSeries(data)
        print("Series: \(series.data)")
        series.color = .orange
        series.area = true
        chartView.add(series)
    }
    

    
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
            // TODO add to the table view when the button is pressed.
            guard let calorieEntry = Double(calorieEntry.text!) else { return }
            self.caloriesController.addCalories(calorieCount: calorieEntry)
            self.updateChartData()
            self.tableView.reloadData()
            print("Adding action btn pressed: \(String(describing: self.fetchedResultsController.fetchedObjects))")
        }))
       
        present(alert, animated: true, completion: nil)
    }

}
// MARK: - Extensions For UITableViewDataSource
extension CalorieTrackerVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let calorie = fetchedResultsController.fetchedObjects?[indexPath.row] else { return UITableViewCell() }
        cell.textLabel?.text = ("Calories: \(calorie.calorieCount)")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        cell.detailTextLabel?.text = dateFormatter.string(from: calorie.timeStamp!) // Why is date optional here?
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let calorie = self.fetchedResultsController.object(at: indexPath)
            self.caloriesController.deleteCalorie(calorie: calorie)
            self.tableView.reloadData()
            updateChartData()
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
    
}



