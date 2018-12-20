//
//  ViewController+Helper.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/11/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController
{
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //it saves the context of the App for further CoreData use
    func save(){
        do {
            try CoreDataStack.shared().saveContext()
            print("Se va a guardar el contexto")
        }
        catch
        {
            showInfo(withTitle: "Error", withMessage: "Error while saving data: \(error)")
        }
    }
    
    //it shows a message to warn the user of any issue or complete process.
    func showInfo(withTitle: String = "Info", withMessage: String,action: (() -> Void)? = nil){
        performUIUpdatesOnMain {
            let ac = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alertAction) in action?()}))
            self.present(ac, animated: true)
        }
    }
    
    //It performs UIUpdates
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void)
    {
        DispatchQueue.main.async {
            updates()
        }
    }
    
    //It loads the Touristic Place that is going to be shown in the map
    public func loadTouristicPlace(latitude: String, longitude: String) -> TouristicPlace? {
        let predicate = NSPredicate(format: "tpLatitude == %@ AND tpLongitude == %@", latitude, longitude)
        var tp: TouristicPlace?
        do {
            try tp = CoreDataStack.shared().fetchTP(predicate, entityName: TouristicPlace.name)
        } catch {
            showInfo(withTitle: "Error", withMessage: "Error while fetching location: \(error)")
        }
        return tp
    }
    
    //It loads the Touristic Place by tpId
    public func loadTouristicPlaceById(tpId: String) -> TouristicPlace? {
        let predicate = NSPredicate(format: "tpId == %@ ", tpId)
        var tp: TouristicPlace?
        do {
            try tp = CoreDataStack.shared().fetchTP(predicate, entityName: TouristicPlace.name)
        } catch {
            showInfo(withTitle: "Error", withMessage: "Error while fetching location: \(error)")
        }
        return tp
    }
    
    //It loads the Visit by vId
    public func loadVisitById(vId: String) -> Visit? {
        let predicate = NSPredicate(format: "vId == %@ ", vId)
        var vs: Visit?
        do {
            try vs = CoreDataStack.shared().fetchVisit(predicate, entityName: Visit.name)
        } catch {
            showInfo(withTitle: "Error", withMessage: "Error while fetching location: \(error)")
        }
        return vs
    }
    
    //Allows to dismiss the keyboard when taps out of the textfield
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //It returns the name of the image to be loaded in the map
    func loadImageMapName(_ type: String) -> String
    {
        var imageMapName = ""
        
        switch(type.uppercased())
        {
        case tpStructures.forest:
            imageMapName = "icon_tp_forest.png"
        case tpStructures.beach:
            imageMapName = "icon_tp_beach.png"
        case tpStructures.lake:
            imageMapName = "icon_tp_lake.png"
        case tpStructures.mountain:
            imageMapName = "icon_tp_mountain.png"
        default:
            imageMapName = "icon_tp_forest.png"
        }
        print(imageMapName)
        return imageMapName
    }
    
    func convertDateTimeToString(_ date: Date,_ format: String) -> String
    {
        var dateTimeString:String = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateTimeString = dateFormatter.string(from: date)
        return dateTimeString
    }
    
    func convertStringToDateTime(_ date: String,_ time: String) -> Date
    {
        let dateFormat = "yyyy/MM/dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let stringDateTime = date+" "+time
        let stringConvertedToDateTime = dateFormatter.date(from:stringDateTime)
        return stringConvertedToDateTime!
    }
}
