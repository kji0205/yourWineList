//
//  WineTableViewController.swift
//  wineList
//
//  Created by jimmy kim on 2018. 3. 4..
//  Copyright © 2018년 yunaz. All rights reserved.
//

import UIKit
import os.log

class WineTableViewController: UITableViewController {

    //MARK: Properties
    let searchController = UISearchController(searchResultsController: nil)
    
    var wines = [Wine]()
    var filteredWines = [Wine]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data.
        if let savedWines = loadWines() {
            wines += savedWines
        }
        else {
            // Load the sample data.
            loadSampleWines()
        }
        
        setupNavBar()
    }
    
    func setupNavBar(){
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        
//        searchController = UISearchController(searchResultsController: nil)
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Wines"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            navigationItem.titleView = searchController.searchBar
        }
        
//        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
    }
    
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredWines = wines.filter({( wine : Wine) -> Bool in
            return wine.name.lowercased().contains(searchText.lowercased())
        })
//        filteredWines = wines.filter({( wine : Wine) -> Bool in
//            let doesCategoryMatch = (scope == "All") || (candy.category == scope)
//
//            if searchBarIsEmpty() {
//                return doesCategoryMatch
//            } else {
//                return doesCategoryMatch && candy.name.lowercased().contains(searchText.lowercased())
//            }
//        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    private func loadSampleWines() {
        
        let photo1 = UIImage(named: "wine1")
        let photo2 = UIImage(named: "wine2")
        let photo3 = UIImage(named: "wine3")
        
        guard let wine1 = Wine(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let wine2 = Wine(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let wine3 = Wine(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal2")
        }
        
        wines += [wine1, wine2, wine3]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering() {
            return filteredWines.count
        }
        return wines.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "WineTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WineTableViewCell  else {
            fatalError("The dequeued cell is not an instance of WineTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
//        let wine = wines[indexPath.row]
        let wine: Wine
        if isFiltering() {
            wine = filteredWines[indexPath.row]
        } else {
            wine = wines[indexPath.row]
        }
        
        cell.nameItem.text = wine.name
        cell.photoImageView.image = wine.photo
        cell.ratingControl.rating = wine.rating
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let wine = wines[indexPath.row]
//        performSegue(withIdentifier: "ShowDetail", sender: wine)
//    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? WineViewController, let wine = sourceViewController.wine {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                wines[selectedIndexPath.row] = wine
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: wines.count, section: 0)
                
                wines.append(wine)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the wines.
            saveWines()
        }
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            wines.remove(at: indexPath.row)
            saveWines()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let wineDetailViewController = segue.destination as? WineViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedWineCell = sender as? WineTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedWineCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
//            let selectedWine = wines[indexPath.row]
            let wine: Wine
            if isFiltering() {
                wine = filteredWines[indexPath.row]
            } else {
                wine = wines[indexPath.row]
            }
            wineDetailViewController.wine = wine
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    //MARK: Private Methods
    private func saveWines() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(wines, toFile: Wine.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Wines successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save wines...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadWines() -> [Wine]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Wine.ArchiveURL.path) as? [Wine]
    }
    
}

extension WineTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
//        let searchBar = searchController.searchBar
//        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
//
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredWines = wines.filter { wine in
                return wine.name.lowercased().contains(searchText.lowercased())
            }
            
        } else {
            filteredWines = wines
        }
        tableView.reloadData()
        
//        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension WineTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
//    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
//        filteredCandies = candies.filter({( candy : Candy) -> Bool in
//            let doesCategoryMatch = (scope == "All") || (candy.category == scope)
//
//            if searchBarIsEmpty() {
//                return doesCategoryMatch
//            } else {
//                return doesCategoryMatch && candy.name.lowercased().contains(searchText.lowercased())
//            }
//        })
//        tableView.reloadData()
//    }
}
