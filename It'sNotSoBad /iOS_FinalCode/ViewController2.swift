//
//  ViewController2.swift
//  iOS_Final
//
//  Created by Alex Jiang on 11/25/19.
//  Copyright © 2019 Michelle Choi. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    //comment this out later since coredata means we have no use for bookkeep
    var bookkeep = [Semester]()
    
    //----------------CIRCLE ANIMATION------------------
    let shapeLayer = CAShapeLayer()
    
    let percentageLabel: UILabel = {
        
        let label = UILabel()
        label.text = "100%"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
        
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        bookkeep.append(Semester())
        
        
        //Setting up coredata to save user records
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Sem", in: context)
        let newSemester = NSManagedObject(entity: entity!, insertInto: context)
        
        //key in this case is "name" and value is a string that is the name of the semester
        newSemester.setValue("Semester1", forKey:"name")
        newSemester.setValue(0, forKey:"sem_gpa")
        
        //array of names of elements
        let temp_names = ["Classes","Internship", "Relationship","Social","Sleep","Hobbies"]
        //array to save elements
        var save_elements = [NSManagedObject]()
        //loop through the array to save each elements to each "Sem"
        for i in 1...6 {
            // Create element
            let element = NSEntityDescription.entityForName("Element", inManagedObjectContext: self.managedObjectContext)
            let newElement = NSManagedObject(entity: element!, insertIntoManagedObjectContext: self.managedObjectContext)
             
            // Populate element
            newElement.setValue(temp_names[i], forKey: "name")
            newElement.setValue(0, forKey: "score")
            newElement.setValue(0, forKey: "weight")
            save_elements.append(newElement)
            
        }
        
        //adding the elements to respective semester
        newSemester.setValue(NSSet(array: save_elements), forKey: "elementss")
        
        //saving data
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
        
        
        //fetching data
        //let newSemesterFetch = NSFetchRequest(entityName: "Element")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Element")
        
        
            //let fetchedSemester = try moc.executeFetchRequest(newSemesterFetch)
            let result = try context.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "name") as! String)
            }
        
        //print(fetchedSemester)
        
            
//
//        //update data
//        //As we know that container is set up in the AppDelegates so we need to refer that container.
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

         //We need to create a context from this container
         let managedContext = appDelegate.persistentContainer.viewContext

         let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
         fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur1")
         do
         {
             let test = try managedContext.fetch(fetchRequest)

                 let objectUpdate = test[0] as! NSManagedObject
                 objectUpdate.setValue("newName", forKey: "username")
                 objectUpdate.setValue("newmail", forKey: "email")
                 objectUpdate.setValue("newpassword", forKey: "password")
                 do{
                     try managedContext.save()
                 }
                 catch
                 {
                     print(error)
                 }
             }
         catch
         {
             print(error)
         }
            
            
            
        print(bookkeep.count)
        
        
        // Do any additional setup after loading the view.
//        view .addSubview(percentageLabel)
//        percentageLabel.frame = CGRect(x: 0, y:0, width: 100, height: 100)
//        percentageLabel.center = view.center
//        let center = view.center
//
//        //track layer
//        let trackLayer = CAShapeLayer()
//        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
//        trackLayer.path = circularPath.cgPath
//
//
//        trackLayer.strokeColor = UIColor(red: CGFloat(211.0/255), green: CGFloat(211.0/255), blue: CGFloat(211.0/255), alpha: CGFloat(1.0)).cgColor
//        trackLayer.lineWidth = 10
//        trackLayer.fillColor = UIColor.clear.cgColor
//        view.layer.addSublayer(trackLayer)
//
//
//
//        shapeLayer.path = circularPath.cgPath
//
//        shapeLayer.strokeColor = UIColor(red: CGFloat(1.0/255), green: CGFloat(223.0/255), blue: CGFloat(215.0/255), alpha: CGFloat(1.0)).cgColor
//        shapeLayer.lineWidth = 10
//        shapeLayer.fillColor = UIColor.clear.cgColor
//
//        //shapeLayer.lineCap = CAShapeLayerLineCap
//        shapeLayer.strokeEnd = 0
//        view.layer.addSublayer(shapeLayer)
//
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
//    @objc private func handleTap() {
//
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.toValue = 1
//        animation.duration = 2
//        animation.fillMode = CAMediaTimingFillMode.forwards
//        animation.isRemovedOnCompletion = false
//        shapeLayer.add(animation, forKey: "basic")
//    }
//    //————————CIRCLE ANIMATION ENDS—————————
//
//
//    @IBOutlet weak var gradeText: UITextField!
//
//    @IBAction func showGrade(_ sender: Any) {
//        // connect grade to circle value
//    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let updateVC = segue.destination as! UpdateViewController
        updateVC.bookkeep = bookkeep

    }

    
    
    @IBAction func toUpdate(_ sender: UIButton) {
        performSegue(withIdentifier: "Identifier", sender: sender)
    }
    
    
    
}
