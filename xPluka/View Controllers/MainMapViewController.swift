//
//  MainMapViewController.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/7/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import Foundation
import MapKit

public class MainMapViewController : UIViewController, MKMapViewDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    
    //It declares the pin point in the map
    var pinAnnotation: MKPointAnnotation? = nil
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    
    //It opens the TPRegisterViewController where the touristic place is registered(NEW)
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerTPSegue"
        {
            guard let pin = sender as? MKPointAnnotation else {
                return
            }
            let controller = segue.destination as! TPRegisterViewController
            controller.tpLatitudeReceived  = String(format: "%.6f",pin.coordinate.latitude)
            controller.tpLongitudeReceived = String(format: "%.6f",pin.coordinate.longitude)
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
            performSegue(withIdentifier: "registerTPSegue", sender: pinAnnotation)
        }
    }
}
