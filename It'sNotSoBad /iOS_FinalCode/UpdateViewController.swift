//
//  UpdateViewController.swift
//  iOS_Final
//
//  Created by Alex Jiang on 11/15/19.
//  Copyright © 2019 Alex Jiang. All rights reserved.
//

import UIKit
import CoreData

let categories = ["Classes", "Internship", "Relationship", "Social", "Sleep", "Hobbies"]


class UpdateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    //define the global array of semesters
    var allSemesters:[NSManagedObject]?
    var sortedSems:[NSManagedObject]? = []


    //*******
    //first coredata function - creating record
    //*******
    func createSemester(sem_name: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Sem", in: context!)
        let newSemester = NSManagedObject(entity: entity!, insertInto: context)

        //key in this case is "name" and value is a string that is the name of the semester
        //******* note that Semester1 is a name of semester and a parameter for the functrion
        newSemester.setValue(sem_name, forKey:"name")
        newSemester.setValue(0.0, forKey:"sem_gpa")
        let key = semestersList().count
        newSemester.setValue(key, forKey: "key")

        //array of names of elements
        let temp_names = ["Classes","Internship", "Relationship","Social","Sleep","Hobbies"]

        //loop through the array to save each elements to each "Sem"
        for i in 0...5 {
            // Create element
            let element = NSEntityDescription.entity(forEntityName: "Element", in: self.context!)
            let newElement = NSManagedObject(entity: element!, insertInto: self.context!)

            // Populate element
            newElement.setValue(temp_names[i], forKey: "name")
            newElement.setValue(0.0, forKey: "score")
            newElement.setValue(0.0, forKey: "weight")
            //note that Semester1 is a name of semester and a parameter for the functrion
            //*********
            //For each semester i look at each element and find the elements with the value aka name of that semester in sem_link. Basically when I want a semester I just loop through all elements to find respective sem_link
            newElement.setValue(sem_name,forKey:"sem_link")
        }

        //saving data
        do {
            try context!.save()
          } catch {
           print("Failed saving")
        }
        allSemesters?.append(newSemester)
    }
    
    //    //*******
    //    //function 2 fetching semester
    //    //********
    func fetchSemester(sem_name:String) -> NSManagedObject{
        let fetchRequestSemester = NSFetchRequest<NSFetchRequestResult>(entityName: "Sem")

        var semester: NSManagedObject?
        do {
            let result = try context!.fetch(fetchRequestSemester)
            for data in result as! [NSManagedObject] {
                if (data.value(forKey: "name") as! String) == sem_name {
                    semester = data
                    break;
                }
            }
        } catch {
            
        }
        
        return semester!
    }
    
    //fetching semester by the key attribute of that semester
    //this solves the issue of tableview displaying semesters out of order
    func fetchSemesterByKey(key:Int) -> NSManagedObject{
        let fetchRequestSemester = NSFetchRequest<NSFetchRequestResult>(entityName: "Sem")

        var semester: NSManagedObject?
        do {
            let result = try context!.fetch(fetchRequestSemester)
            for data in result as! [NSManagedObject] {
                if (data.value(forKey: "key") as! Int) == key {
                    semester = data
                    break;
                }
            }
        } catch {
            
        }
        

        return semester!
    }

    //    //*******
    //    //function 3 fetching semester element
    //    //********
    //when fetching element run this function in a loop of length 6 to get all the elements
    func fetchSemesterElement(semester: NSManagedObject) -> [NSManagedObject]{
        let fetchRequestElement = NSFetchRequest<NSFetchRequestResult>(entityName: "Element")
        var elements = [NSManagedObject]()
        do {
            let result = try context!.fetch(fetchRequestElement)
            
            for data in result as! [NSManagedObject] {
                if (data.value(forKey: "sem_link") as! String) == (semester.value(forKey: "name") as! String) {
                    elements.append(data)
                }
            }
            
        } catch {
            
        }
        return elements
    }
    
    //*******
    //extra function to return a list of all semester objects
    //use this for setting up the tableview
    //*******
    func semestersList() -> [NSManagedObject]{
        let fetchRequestSemester = NSFetchRequest<NSFetchRequestResult>(entityName: "Sem")
        var semList: [NSManagedObject]?
        do{
            let result = try context!.fetch(fetchRequestSemester)
            
            semList = (result as! [NSManagedObject])
        } catch{
            
        }
        return semList!
    }
    
    
    var thisSemester:String?
    var thisCategory:String?
    
    func numberOfSections(in tableView: UITableView) -> Int {        
        if let sem = allSemesters {
            return sem.count
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // if there is at least one semester, we sort the semesters by their key value
        if(allSemesters?.count != 0) {
            var keys:[Int] = []
            for sem in allSemesters! {
                keys.append(sem.value(forKey: "key") as! Int)
            }
            keys.sort()
            sortedSems = []
            let numSems = allSemesters!.count
            for i in 1...numSems {
                let thisSem = fetchSemesterByKey(key: i)
                sortedSems?.append(thisSem)
            }
        }
        // we use the section Int to determine which header will be displayed
        // we take the name of the semester in position sortedSems[section]
        return (sortedSems?[section].value(forKey: "name") as! String)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return 6 since we have 6 elements in Semester class
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // use indexPath to determine which category to display
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultId", for: indexPath)
        
        cell.textLabel?.text = "\(categories[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // use indexPath to determine which cell the user selected
        // depending on indexPath, we can perform a segue and display using the correct semester and category
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)

        thisSemester = sortedSems![indexPath.section].value(forKey: "name") as? String

        thisCategory = cell?.textLabel?.text
        
        performSegue(withIdentifier: "cellClicked", sender: cell)
    }
    
    @IBOutlet weak var semesterTableView: UITableView!
    
    //*******
    //button to update GPA when user pressed back button
    //********

    @IBAction func back(_ sender: UIBarButtonItem) {
        let vc = self.presentingViewController as! ViewControllerActual
        vc.updateFinalGPA()
        dismiss(animated: true, completion: nil)
        
        
    }
    
    //*******
    //function to create an alert when the user pressed "Add Semester"
    //********
    @IBAction func add_sem(_ sender: Any) {
        let alert = UIAlertController(title: "Add a Semester", message: "Input semester name", preferredStyle: .alert)
        
        alert.addTextField {
            (textField) in textField.text = "Your Name"
        }
        
        // if the semester adds a semester and inputs a valid semester name, a new semester is created and added to tableView
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            
            if (textField.text != "") {
                self.createSemester(sem_name: textField.text!)
                var keys:[Int] = []
                for sem in self.allSemesters! {
                    keys.append(sem.value(forKey: "key") as! Int)
                }
                keys.sort()
                self.sortedSems = []
                let numSems = self.allSemesters!.count
                for i in 1...numSems {
                    let thisSem = self.fetchSemesterByKey(key: i)
                    self.sortedSems?.append(thisSem)
                }
            }
            self.semesterTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //set up core data
    var appDelegate: AppDelegate?
    
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        semesterTableView.delegate = self
        semesterTableView.dataSource = self
        
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        
        context = self.appDelegate!.persistentContainer.viewContext
        
        allSemesters = semestersList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.destination is UpdateSemesterViewController {
            // Create an instance of PlayerTableViewController and pass the variable
            let destinationVC = segue.destination as? UpdateSemesterViewController
            destinationVC?.semesterName = thisSemester
            destinationVC?.categoryName = thisCategory
        }
        
    }
}
