//
//  ViewControllerActual.swift
//  iOS_Final
//
//  Created by Alex Jiang on 11/25/19.
//  Copyright © 2019 Alex Jiang. All rights reserved.
//


import UIKit
import CoreData

class ViewControllerActual: UIViewController {
    
    var finalGrade:Double = 0.0
    var thisSemesterGrade:Double = 0.0
    var lastSemesterGrade:Double = 0.0
    var sortedSems:[NSManagedObject?] = []
    
    //*******
    //first coredata function - creating record of a semester
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

            //newSemester.setValue(newElement, forKey: "elementss")
        }

        //saving data
        do {
            try context!.save()
          } catch {
           print("Failed saving")
        }
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
                    semester = data //theSemester Object?
                    break;
                }
            }
        } catch {
            print("Failed")
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
            print("Failed")
        }
        return semester!
    }
    
    //*******
    //return a list of all semester objects
    //use this for setting up the tableview
    //*******
    func semestersList() -> [NSManagedObject]{
        let fetchRequestSemester = NSFetchRequest<NSFetchRequestResult>(entityName: "Sem")
        var semList: [NSManagedObject]?
        do{
            let result = try context!.fetch(fetchRequestSemester)
            
            semList = (result as! [NSManagedObject])
        } catch{
            print("Failed")
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
            print("Failed")
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
            total += (10*(element.value(forKey:"score")as! Float)) * (10*(element.value(forKey:"weight")as! Float))
        
        }
        semester.setValue(total, forKey: "sem_gpa")
    }
    

    var appDelegate: AppDelegate?
    
    var context: NSManagedObjectContext?
    
    let shapeLayer = CAShapeLayer()
    
    var pulseLayer: CAShapeLayer!
       
    let thisSemesterShapeLayer = CAShapeLayer()
    
    let lastSemesterShapeLayer = CAShapeLayer()
    
    //*******
    //create three percentage labels to be displayed on home screen
    //********
    let percentageLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
        
    }()
    
    let thisSemesterPercentageLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
        
    }()
    
    
    let lastSemesterPercentageLabel: UILabel = {
            
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
            
    }()

    //*******
    //viewDidLoad allows for deletion of records if necessary, and updates the information displayed on home screen
    //********
    override func viewDidLoad() {
            super.viewDidLoad()
        
            //initial setting up of coredata
            appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            
            context = self.appDelegate!.persistentContainer.viewContext
        
        //disable these 2 buttons if there are no semesters
        if semestersList().count == 0{
            toStats.isEnabled = false
            toVideo.isEnabled = false
        }

        
        //deleting all of data in coredata
        func deleteAllRecords() {

            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Sem")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

            do {
                try context!.execute(deleteRequest)
                try context!.save()
            } catch {
                print ("There was an error")
            }
        }
        func deleteAllRecords2() {

            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Element")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

            do {
                try context!.execute(deleteRequest)
                try context!.save()
            } catch {
                print ("There was an error")
            }
        }
        
        //comment to delete all data and start with clean slate and uncomment to not use
        //deleteAllRecords()
        //deleteAllRecords2()
        
        // update final GPA
         updateFinalGPA()
        
        //————————CIRCLE ANIMATION STARTS—————————
          percentageLabel.text = "\(Int(finalGrade))%"
          percentageLabel.textColor = UIColor(red: CGFloat(76.0/255), green: CGFloat(76.0/255), blue: CGFloat(76.0/255), alpha: CGFloat(1.0))
          view .addSubview(percentageLabel)
          percentageLabel.frame = CGRect(x: 0, y:0, width: 100, height: 100)
          percentageLabel.center = view.center
          let center = view.center
          
            
          // create track layer
          let trackLayer = CAShapeLayer()
          let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
          trackLayer.path = circularPath.cgPath
          
          // set stroke color, width, and fill
          trackLayer.strokeColor = UIColor(red: CGFloat(211.0/255), green: CGFloat(211.0/255), blue: CGFloat(211.0/255), alpha: CGFloat(1.0)).cgColor
          trackLayer.lineWidth = 13
          trackLayer.fillColor = UIColor.clear.cgColor
          view.layer.addSublayer(trackLayer)
        
          
          shapeLayer.path = circularPath.cgPath
          shapeLayer.strokeColor = UIColor(red: CGFloat(0.0/255), green: CGFloat(169.0/255), blue: CGFloat(254.0/255), alpha: CGFloat(1.0)).cgColor
          shapeLayer.lineWidth = 13
          shapeLayer.fillColor = UIColor.clear.cgColor
          shapeLayer.strokeEnd = 0
          view.layer.addSublayer(shapeLayer)
                  
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        // animation.toValue = (overallGrade/100)*0.80 <-- use when we have the actual overall grade variable
        // for some reason the circle fill is out of 0.8 and not 1.0
        animation.toValue = finalGrade/100*0.80
        animation.duration = 2
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "basic")
        //————————CIRCLE ANIMATION ENDS—————————
        
        // call the funtions to update thisSemester and lastSemester, respectively
        updateThisSemester()
        updateLastSemester()
    
    }
        
    @IBOutlet weak var gradeLabel: UILabel!

    @IBAction func toupdate(_ sender: UIButton) {
        toStats.isEnabled = true
        toVideo.isEnabled = true
        performSegue(withIdentifier: "Identifier", sender: sender)
    }
    
    @IBOutlet weak var toStats: UIButton!
    
    @IBOutlet weak var toVideo: UIButton!
    
    @IBAction func toStats(_ sender: UIButton) {
        performSegue(withIdentifier: "Identifier2", sender: sender)
    }
    
    
    @IBAction func toVideo(_ sender: UIButton) {
        performSegue(withIdentifier: "Identifier3", sender: sender)
    }
    
    //*******
    //use the function semestersList() to get semester values in order to calculate final GPA
    //********
    func updateFinalGPA() {
        
        let all_semesters = semestersList()
        // if there are no semesters, all grades display 0%
        if(all_semesters.count == 0) {
            gradeLabel.text = "0%"
            percentageLabel.text = "0%"
            thisSemesterPercentageLabel.text = "0%"
            lastSemesterPercentageLabel.text = "0%"
        }
        
        else {
            
            var gpa_total:Float = 0.00
            // use a for loop to loop through all semesters and calculate GPA
            for sem in all_semesters {
                let all_elements = fetchSemesterElement(semester: sem)
                updateSemesterGPA(semester: sem, elements: all_elements)
                let gpa = sem.value(forKey: "sem_gpa")
                let floatGPA = gpa as! Float
                gpa_total += floatGPA
            }
            finalGrade = Double(round(10*(gpa_total/Float(all_semesters.count))/10))
            gradeLabel.text = "\(Int(finalGrade))%"
            percentageLabel.text = "\(Int(finalGrade))%"
        }
        
        // animates when updateFinalGPA() is called
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = finalGrade/100*0.80
        animation.duration = 2
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "basic")
        
        // thisSemester and lastSemester also need to be updated when finalGPA is updated, so we call the two functions
        updateThisSemester()
        updateLastSemester()
    }
    
    //*******
    //function to update current, or most recent, semester
    //********
    func updateThisSemester() {
        
        // sort semesters by key
        let all_semesters = semestersList()
        if(all_semesters.count != 0) {
            var keys:[Int] = []
            for sem in all_semesters {
                keys.append(sem.value(forKey: "key") as! Int)
            }
            keys.sort()
            let numSems = all_semesters.count
            sortedSems = []
            for i in 1...numSems {
                let thisSem = fetchSemesterByKey(key: i)
                sortedSems.append(thisSem)
            }
            
            // once sorted, we know that thisSemester will be the last element in the sortedSems array
            thisSemesterGrade = sortedSems[all_semesters.count-1]?.value(forKey: "sem_gpa") as! Double
        }

        if(all_semesters.count == 0) {
            thisSemesterPercentageLabel.text = "N/A"
        }
        else {
            thisSemesterPercentageLabel.text = "\(Int(thisSemesterGrade))%"
        }
              view .addSubview(thisSemesterPercentageLabel)
              thisSemesterPercentageLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        thisSemesterPercentageLabel.center = CGPoint(x: 300, y: 650)
              let thisSemesterCenter = CGPoint(x: 300, y: 650)
              
                
              let thisSemesterTrackLayer = CAShapeLayer()
              let thisSemesterCircularPath = UIBezierPath(arcCenter: thisSemesterCenter, radius: 50, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
              thisSemesterTrackLayer.path = thisSemesterCircularPath.cgPath
              
            
              thisSemesterTrackLayer.strokeColor = UIColor(red: CGFloat(211.0/255), green: CGFloat(211.0/255), blue: CGFloat(211.0/255), alpha: CGFloat(1.0)).cgColor
              thisSemesterTrackLayer.lineWidth = 13
              thisSemesterTrackLayer.fillColor = UIColor.clear.cgColor
              view.layer.addSublayer(thisSemesterTrackLayer)
              
              
              thisSemesterShapeLayer.path = thisSemesterCircularPath.cgPath
              
        thisSemesterShapeLayer.strokeColor = UIColor(red: CGFloat(255.0/255), green: CGFloat(32.0/255), blue: CGFloat(121.0/255), alpha: CGFloat(1.0)).cgColor
              thisSemesterShapeLayer.lineWidth = 13
              thisSemesterShapeLayer.fillColor = UIColor.clear.cgColor
              
              //shapeLayer.lineCap = CAShapeLayerLineCap
              thisSemesterShapeLayer.strokeEnd = 0
              view.layer.addSublayer(thisSemesterShapeLayer)
        
        // animate this semester
        let thisSemesterAnimation = CABasicAnimation(keyPath: "strokeEnd")
          thisSemesterAnimation.toValue = thisSemesterGrade/100*0.80
          thisSemesterAnimation.duration = 2
          thisSemesterAnimation.fillMode = CAMediaTimingFillMode.forwards
          thisSemesterAnimation.isRemovedOnCompletion = false
          thisSemesterShapeLayer.add(thisSemesterAnimation, forKey: "basic")
        
    }
    
    //*******
    //function to update last semester
    //********
    func updateLastSemester() {
        
        let all_semesters = semestersList()

        // sort semesters by key
        // once semesters are sorted, we know that lastSemester is the second to last element in the semester array
        if(all_semesters.count > 1) {
            var keys:[Int] = []
            for sem in all_semesters {
                keys.append(sem.value(forKey: "key") as! Int)
            }
            keys.sort()
            let numSems = all_semesters.count
            sortedSems = []
            for i in 1...numSems {
                let thisSem = fetchSemesterByKey(key: i)
                sortedSems.append(thisSem)
            }
            lastSemesterGrade = sortedSems[all_semesters.count-2]?.value(forKey: "sem_gpa") as! Double
        }
        else {
            lastSemesterGrade = 0.0
        }
        
        // animate lastSemester on home screen
        let lastSemesterAnimation = CABasicAnimation(keyPath: "strokeEnd")
        lastSemesterAnimation.toValue = lastSemesterGrade/100*0.80
        lastSemesterAnimation.duration = 2
        lastSemesterAnimation.fillMode = CAMediaTimingFillMode.forwards
        lastSemesterAnimation.isRemovedOnCompletion = false
        lastSemesterShapeLayer.add(lastSemesterAnimation, forKey: "basic")
        if(all_semesters.count > 1) {
            lastSemesterPercentageLabel.text = "\(Int(lastSemesterGrade))%"
        }
        else {
            lastSemesterPercentageLabel.text = "N/A"
        }
          view .addSubview(lastSemesterPercentageLabel)
          lastSemesterPercentageLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
          lastSemesterPercentageLabel.center = CGPoint(x: 100, y: 650)
          let lastSemesterCenter = CGPoint(x: 100, y: 650)
          
            
          //track layer
          let lastSemesterTrackLayer = CAShapeLayer()
          let lastSemesterCircularPath = UIBezierPath(arcCenter: lastSemesterCenter, radius: 50, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
          lastSemesterTrackLayer.path = lastSemesterCircularPath.cgPath
          
        
          lastSemesterTrackLayer.strokeColor = UIColor(red: CGFloat(211.0/255), green: CGFloat(211.0/255), blue: CGFloat(211.0/255), alpha: CGFloat(1.0)).cgColor
          lastSemesterTrackLayer.lineWidth = 13
          lastSemesterTrackLayer.fillColor = UIColor.clear.cgColor
          view.layer.addSublayer(lastSemesterTrackLayer)
          
          
          lastSemesterShapeLayer.path = lastSemesterCircularPath.cgPath
          
          lastSemesterShapeLayer.strokeColor = UIColor(red: CGFloat(254.0/255), green: CGFloat(251.0/255), blue: CGFloat(102.0/255), alpha: CGFloat(1.0)).cgColor
          lastSemesterShapeLayer.lineWidth = 13
          lastSemesterShapeLayer.fillColor = UIColor.clear.cgColor
          
          //shapeLayer.lineCap = CAShapeLayerLineCap
          lastSemesterShapeLayer.strokeEnd = 0
          view.layer.addSublayer(lastSemesterShapeLayer)
                  
    }
    
}
