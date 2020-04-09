//
//  StatsViewController.swift
//  iOS_Final
//
//  Created by Alex Jiang on 12/10/19.
//  Copyright © 2019 Alex Jiang. All rights reserved.
//

import UIKit
import CoreData

class StatsViewController: UIViewController {

    @IBOutlet weak var weightChart: CurvedBarChart!
    @IBOutlet weak var scoreChart: CurvedBarChart!
    
    @IBAction func backHome(_ sender: UIBarButtonItem) {
        timer!.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    
    
    let numEntry = 6
    var labels = ["Classes","Internship", "Relationship","Social","Sleep","Hobbies"]
    
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
                    semester = data //theSemester Object?
                    break;
                }            }
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
    
    var appDelegate: AppDelegate?
    
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        
        context = self.appDelegate!.persistentContainer.viewContext
    }
    
    var timer: Timer?
    var semNameLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
    
        //fetchSemesterbyKey(i) to get the semester
        //give it to function below
        //initialize the function again for weights
        let dataEntriesWeight = generateEmptyDataEntries()
        let dataEntriesScore = generateEmptyDataEntries()
        weightChart.updateDataEntries(dataEntries: dataEntriesWeight, animated: false)
        scoreChart.updateDataEntries(dataEntries: dataEntriesScore, animated: false)
        
        var counter = 1
        
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) {[unowned self] (timer) in
            
            if self.semNameLabel != nil{
                self.semNameLabel.removeFromSuperview()
            }
            self.semNameLabel = UILabel()
            self.semNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
            self.semNameLabel.text = (self.fetchSemesterByKey(key: counter).value(forKey: "name") as! String)
            self.semNameLabel.sizeToFit()
            self.semNameLabel.center = CGPoint(x:320, y:102)
            self.view.addSubview(self.semNameLabel)
            
            //add some number to continously go through if it hits the lenght
            //of sem_list function then go back to 1.
            let dataEntriesWeight = self.generateDataEntries(semkey: counter, evaluation: 0)
            let dataEntriesScore = self.generateDataEntries(semkey: counter, evaluation: 1)
            self.scoreChart.updateDataEntries(dataEntries: dataEntriesWeight, animated: true)
            self.weightChart.updateDataEntries(dataEntries: dataEntriesScore, animated: true)

            if counter == self.semestersList().count{
                counter = 1
            }
            else{
                counter += 1
            }

        }
        timer!.fire()
        
    }
    
    func generateEmptyDataEntries() -> [DataEntry] {
        var result: [DataEntry] = []
        Array(0..<numEntry).forEach {_ in
            result.append(DataEntry(color: UIColor.clear, height: 0, textValue: "0", title: ""))
        }
        return result
    }
    
    //if evaluation is 0 then displays weight
    //if evaluation is 1 then displays score
    func generateDataEntries(semkey: Int,evaluation: Int) -> [DataEntry] {
        //give it an input, a semester link integer
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [DataEntry] = []
        for i in 0...5 {
            //go through all elements and if the element.name = the name in labels[i]
            //and element.semlink = sem then set the element.score
            for ele in fetchSemesterElement(semester: fetchSemesterByKey(key: semkey)){
                if ((ele.value(forKey: "name") as!String) == labels[i]) && (evaluation == 1){
                    
                    let value = (ele.value(forKey: "weight") as!Float)
                    let height: Float = Float(value)
                    
                    result.append(DataEntry(color: colors[i % colors.count], height: height, textValue: String(format:"%.0f",(ele.value(forKey: "weight") as!Float)*100), title: labels[i]))
                }
                    
                else if ((ele.value(forKey: "name") as!String) == labels[i]) && (evaluation == 0){
                    
                    let value = (ele.value(forKey: "score") as!Float)
                    let height: Float = Float(value)
                    
                    print(String(format:"%.0f",(ele.value(forKey: "score") as!Float)*100))
                    result.append(DataEntry(color: colors[i % colors.count], height: height, textValue: String(format:"%.0f",(ele.value(forKey: "score") as!Float)*100), title: labels[i]))
                }
            }
        }
        return result
    }

}
