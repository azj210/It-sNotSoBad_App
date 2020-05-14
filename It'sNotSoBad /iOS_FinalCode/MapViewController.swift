//
//  MapViewController.swift
//  iOS_Final
//
//  Created by Alex Jiang on 12/16/19.
//  Copyright © 2019 Alex Jiang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 2500
    
    @IBAction func backVideo(_ sender: UIBarButtonItem) {
        //let vc = self.presentingViewController as! ViewControllerActual
        dismiss(animated: true, completion: nil)
    }
    
    var appDelegate: AppDelegate?
    
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        
        context = self.appDelegate!.persistentContainer.viewContext
        checkLocationServices()
        mapView.showsUserLocation = true
        // Do any additional setup after loading the view.
    }
    
    //CoreData Functions
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
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            //setup location manager
            setupLocationManager()
            checkLocationAuthorization()
            
        } else{
            //Show alert
        }
    }
    
    //asking user permission to use location
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //Engage with map
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            populateNearByPlaces()
            break
        case .denied:
            //User does not allow
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }
    
    //Maprequest to give user locations near him/her
    func populateNearByPlaces() {
        //get region of local businesses you want
        var region = MKCoordinateRegion()
        region.center = CLLocationCoordinate2D(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
        let request = MKLocalSearch.Request()
        //deciding which businesses to generate
        let thisSem = fetchSemesterByKey(key: semestersList().count)
        var thisEle = fetchSemesterElement(semester: thisSem)[0]
        for ele in fetchSemesterElement(semester: thisSem){
            //if next element in list's weight is greater than current element then
            //choose next element's weight
            if (ele.value(forKey: "weight") as!Float) > (thisEle.value(forKey:"weight") as!Float){
                thisEle = ele
            }
        }
        print(thisEle)
        //if internship is their highest weight but they are not doing excellent
        if (((thisEle.value(forKey: "name") as!String) == "Internship") && ((thisEle.value(forKey: "score") as!Float) <= 0.85)){
            request.naturalLanguageQuery = "Career Services"
        }

        //relationship
        else if (((thisEle.value(forKey: "name") as!String) == "Relationship") && ((thisEle.value(forKey: "score") as!Float) <= 0.85)){
            request.naturalLanguageQuery = "Florist"
        }

        //classes
        else if (((thisEle.value(forKey: "name") as!String) == "Classes") && ((thisEle.value(forKey: "score") as!Float) <= 0.85)){
            request.naturalLanguageQuery = "Library"
        }

        //hobbies
        else if (((thisEle.value(forKey: "name") as!String) == "Hobbies") && ((thisEle.value(forKey: "score") as!Float) <= 0.85)){
            request.naturalLanguageQuery = "Restaurants"
        }


        //sleep
        else if (((thisEle.value(forKey: "name") as!String) == "Sleep") && ((thisEle.value(forKey: "score") as!Float) <= 0.85)){
            request.naturalLanguageQuery = "Mattress Store"
        }

        //social
        else if (((thisEle.value(forKey: "name") as!String) == "Social") && ((thisEle.value(forKey: "score") as!Float) <= 0.85)){
            request.naturalLanguageQuery = "Parks"
        }

        //else
        else{
            request.naturalLanguageQuery = "bars"
        }
        //request.naturalLanguageQuery = "Restaurant"
        request.region = region
        
        //Search for the businesses
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else{
                return
            }
            for item in response.mapItems {
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                
                DispatchQueue.main.async{
                    self.mapView.addAnnotation(annotation)
                }
            }
            //print(response?.mapItems)
        }
        
    }


}

extension MapViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region,animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        
    }
    
}
