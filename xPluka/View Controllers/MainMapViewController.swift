//
//  MainMapViewController.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/7/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import Foundation
import MapKit

public class MainMapViewController : UIViewController, MKMapViewDelegate,TPRegisterViewControllerPassDataBackward
{
    //Allows to reload the map status from the registerTPViewController,when a new TP is created
    func isReloadMap(_ mapStatus:Bool)
    {
        self.reloadMapStatus = mapStatus
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    var transactionMode = ""
    var viewControllerTitleForTransactionMode = ""
    var touristicPlace:TouristicPlace?
    
    //It declares the pin point in the map
    var pinAnnotation: MKPointAnnotation? = nil
    
    //It allows to reload all the map pins
    var reloadMapStatus:Bool=false
    
    override public func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.delegate = self
        setInitialPoint(CLLocation(latitude: -2.0023, longitude: -79.234))
        
        //If there are pins in the map then show them
        if let touristicPlaces = loadAllTouristicPlaces() {
            showTouristicPlaces(touristicPlaces)
        }
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        if (reloadMapStatus)
        {
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            //If there are pins in the map then show them
            if let touristicPlaces = loadAllTouristicPlaces() {
                showTouristicPlaces(touristicPlaces)
            }
        }
    }
    @IBAction func showInformation(_ sender: Any) {
        
        var message = "\nIt allows to create Touristic Places by long pressing in the map surface.\n\n"
        message += "After the creation, it can be seen with an icon referent to its type.\n\n"
        message += "By pressing in a Touristic Place, then it allows to update its information.\n"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        
        // Create the string object
        let alertMessge = NSMutableAttributedString(string: message,
            attributes: [
                NSAttributedStringKey.paragraphStyle: paragraphStyle,
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13),
                NSAttributedStringKey.foregroundColor : UIColor.black
            ]
        )
        
        showInformation(withMessage: alertMessge)
    }
    
    //It opens the TPRegisterViewController where the touristic place is registered(NEW)
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerTPSegue"
        {
            guard let pin = sender as? MKPointAnnotation else {
                return
            }
            let controller = segue.destination as! TPRegisterViewController
            controller.delegate = self
            controller.title = viewControllerTitleForTransactionMode
            controller.tpLatitudeReceived  = String(pin.coordinate.latitude)
            controller.tpLongitudeReceived = String(pin.coordinate.longitude)
            controller.tpTransactionMode = transactionMode
            controller.tpTouristicPlace = touristicPlace
            
            if touristicPlace != nil {
            print("Datos tp enviados")
            print("nombre "+(touristicPlace?.tpName!)!)
            print("latitud "+(touristicPlace?.tpLatitude!)!)
            print("longitud "+(touristicPlace?.tpLongitude!)!)
            }
        }
    }
    
    //It adds a pin point in the map when user press and hold in the map viewcontroller
    @IBAction func addPinGesture(_ sender: UILongPressGestureRecognizer) {
        
        //it gets the location coordinates when the user press and hold in the map
        let location = sender.location(in: mapView)
        let locCoord = mapView.convert(location, toCoordinateFrom: mapView)
        
        if sender.state == .began {
            //it sets the coordinates to the pin annotation then add it to the mapview for later save
            pinAnnotation = MKPointAnnotation()
            pinAnnotation!.coordinate = locCoord
            //mapView.addAnnotation(pinAnnotation!)
            
        } else if sender.state == .changed {
            pinAnnotation!.coordinate = locCoord
        } else if sender.state == .ended {
            //when user end the process of hold the pin then it saves in the Pin entity and then it is saved
            transactionMode = "INSERT"
            viewControllerTitleForTransactionMode = "Register Touristic Place"
            touristicPlace = nil
            performSegue(withIdentifier: "registerTPSegue", sender: pinAnnotation)
        }
    }
    
    //It loads all the pins that are stored in the CoreData
    public func loadAllTouristicPlaces() -> [TouristicPlace]? {
        var tps: [TouristicPlace]?
        do {
            try tps = CoreDataStack.shared().fetchAllTP(entityName: TouristicPlace.name)
        } catch {
            showInfo(withTitle: "Error", withMessage: "Error while fetching Pin locations: \(error)")
        }
        return tps
    }
    
    //It shows the pins in the map after being loaded in CoreData
    func showTouristicPlaces(_ tps: [TouristicPlace]) {
        for tp in tps where tp.tpLatitude != nil && tp.tpLongitude != nil {
            let annotation = MKPointAnnotation()
            let lat = Double(tp.tpLatitude!)!
            let lon = Double(tp.tpLongitude!)!
            annotation.coordinate = CLLocationCoordinate2DMake(lat, lon)
            annotation.title = tp.tpName
            annotation.subtitle = tp.tpType
            mapView.addAnnotation(annotation)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
}

extension MainMapViewController {
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "touristicPlace"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        var imageRender = UIImage()
        if let tp = loadTouristicPlace(latitude: String(annotation.coordinate.latitude), longitude: String(annotation.coordinate.longitude))
        {
            print("Tipo a renderizar "+tp.tpType!)
            imageRender = UIImage(named: loadImageMapName(tp.tpType!))!
        }
        
        if annotationView == nil
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = true
            annotationView?.image = imageRender
        }
        else
        {
            annotationView?.image = imageRender
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            self.showInfo(withMessage: "No link defined.")
        }
    }
    
    //method to show the next ViewController when the user press in a loaded pin in the map
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else {
            return
        }
        let point = CGPoint(x:annotation.coordinate.latitude,y:annotation.coordinate.longitude)
        pinAnnotation = MKPointAnnotation()
        let locCoord = mapView.convert(point, toCoordinateFrom: mapView)
        pinAnnotation!.coordinate = locCoord
        transactionMode = "UPDATE"
        viewControllerTitleForTransactionMode = "Edit Touristic Place"
        touristicPlace = nil
        if let tp = loadTouristicPlace(latitude: String(annotation.coordinate.latitude),longitude: String(annotation.coordinate.longitude))
        {
            touristicPlace = tp
        }
        performSegue(withIdentifier: "registerTPSegue", sender: pinAnnotation)
    }
    
    //method to center the initial point in the map
    public func setInitialPoint(_ location:CLLocation)
    {
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        mapView.setRegion(region, animated: true)
    }
    
    //It loads all the pins that are stored in the CoreData
    private func loadAllVisits() -> [Visit]? {
        var vs: [Visit]?
        do {
            try vs = CoreDataStack.shared().fetchAllVisits(entityName: Visit.name)
        } catch {
            showInfo(withTitle: "Error", withMessage: "Error while fetching Visits: \(error)")
        }
        return vs
    }
    
    //it shows a message to warn the user of any issue or complete process.
    func showInformation(withTitle: String = "Instructions", withMessage: NSMutableAttributedString,action: (() -> Void)? = nil){
        performUIUpdatesOnMain {
            let ac = UIAlertController(title: withTitle, message: "", preferredStyle: .alert)
            ac.setValue(withMessage, forKey: "attributedMessage")
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alertAction) in action?()}))
            self.present(ac, animated: true)
        }
    }
    
}
