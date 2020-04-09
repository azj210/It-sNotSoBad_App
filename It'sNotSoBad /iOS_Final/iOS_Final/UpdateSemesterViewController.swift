//
//  UpdateSemesterViewController.swift
//  iOS_Final
//
//  Created by Alex Jiang on 11/15/19.
//  Copyright © 2019 Alex Jiang. All rights reserved.
//

import UIKit
import CoreData

class UpdateSemesterViewController: UIViewController {
    
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
    //function 4 - update name for semester
    //*******
    func updateSemesterName(semester: NSManagedObject,new_name:String){
        let all_elements = fetchSemesterElement(semester: semester)
        for element in all_elements{
            element.setValue(new_name, forKey:"sem_link")
        }
        semester.setValue(new_name, forKey:"name")
        do {
            try context!.save()
          } catch {
           print("Failed saving")
        }

    }
    
    //*******
    //function 5,6,7 - update data for an element of a semester
    //*******
    func updateSemesterElementScore(element:NSManagedObject, new_score: Float){
        element.setValue(new_score, forKey: "score")
        do {
            try context!.save()
          } catch {
           print("Failed saving")
        }
    }
    func updateSemesterElementWeight(element:NSManagedObject, new_weight: Float){
        element.setValue(new_weight, forKey: "weight")
        do {
            try context!.save()
          } catch {
           print("Failed saving")
        }
    }
    
    //every time update element is called then call this function too
    //******
    //function 8 - update semester gpa after updating an element
    //*****
    func updateSemesterGPA(semester:NSManagedObject,elements:[NSManagedObject]){
        var total:Float = 0.0
        for element in elements{
            total += ((element.value(forKey:"score") as! Float) * (element.value(forKey:"weight") as! Float))
        
        }
        semester.setValue(total, forKey: "sem_gpa")
    }

    
    var semesterName : String?
    var categoryName : String?
    
    //Initialize coredata
    var appDelegate: AppDelegate?
    
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        
        context = self.appDelegate!.persistentContainer.viewContext
        
        let sem = fetchSemester(sem_name: semesterName!)
        let all_elements = fetchSemesterElement(semester: sem)
        
        
        semesterNameLabel.text = semesterName
        categoryLabel.text = categoryName
        
        for element in all_elements{
            if((element.value(forKey: "name") as! String) == categoryName) {
                weightSlider.value = element.value(forKey: "weight") as! Float
                scoreSlider.value = element.value(forKey: "score") as! Float

                weightLabel.text = "\((Int)(weightSlider.value*100))%"
                scoreLabel.text = "\((Int)(scoreSlider.value*100))%"
            }
        }
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        //segue back to update VC and send info back
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var semesterNameLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var weightSlider: UISlider!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var scoreSlider: UISlider!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func weightSliderChanged(_ sender: Any) {
        //use floor because user only sees the whole number when choosing weight
        weightLabel.text = "\((Int)(floor(weightSlider.value*100)))%"
    }
    
    @IBAction func scoreSliderChanged(_ sender: Any) {
        //use floor because user only sees the whole number when choosing weight
        scoreLabel.text = "\((Int)(floor(scoreSlider.value*100)))%"
    }
    
    @IBAction func updateCategory(_ sender: Any) {
        // add category, weight and score to core data?
        
        let sem = fetchSemester(sem_name: semesterName!)
        let all_elements = fetchSemesterElement(semester: sem)
        
        // checks if the category name matches and updates weight and score accordingly
        for element in all_elements{
            if((element.value(forKey: "name") as! String) == categoryName) {
                updateSemesterElementScore(element: element, new_score: (Float(Int(floor(100*scoreSlider.value)))/100))
                updateSemesterElementWeight(element: element, new_weight: (Float(Int(floor(100*weightSlider.value)))/100))
                updateSemesterGPA(semester: sem, elements: all_elements)
            }
        }

        dismiss(animated: true, completion: nil)
    }

}
