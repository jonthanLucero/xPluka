//
//  VisitRegisterViewController.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/18/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class VisitRegisterViewController: UIViewController
{
    //Declaration of variables to use the controls
    @IBOutlet weak var saveUpdateVisit: UIButton!
    @IBOutlet weak var commentary: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var touristicPlace: UITextField!
    
    private var startdatePicker : UIDatePicker?
    private var startTimePicker : UIDatePicker?
    private var enddatePicker : UIDatePicker?
    private var endtimePicker : UIDatePicker?
    
    var visitTransactionMode:String=""
    var visitToBeUpdated:Visit?
    
    var touristicPlaces = [TouristicPlace]()
    var pickerView = UIPickerView()
    var touristicPlaceSelectedId : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        configureDateTimePickers()
        configureTouristicPlacePicker()
        
        if (visitTransactionMode == "INSERT")
        {
            startDate.text = setDate()
            startTime.text = setTime()
            endDate.text = setDate()
            endTime.text = setTime()
        }
        
        if(visitTransactionMode == "UPDATE")
        {
            touristicPlace.text = visitToBeUpdated?.touristiPlaceVisit?.tpName
            startDate.text = convertDateTimeToString((visitToBeUpdated?.vPlannificationDateBegin)!, "yyyy/MM/dd")
            startTime.text = convertDateTimeToString((visitToBeUpdated?.vPlannificationDateBegin)!, "HH:mm:ss")
            endDate.text   = convertDateTimeToString((visitToBeUpdated?.vPlannificationDateEnd)!, "yyyy/MM/dd")
            endTime.text   = convertDateTimeToString((visitToBeUpdated?.vPlannificationDateEnd)!, "HH:mm:ss")
            commentary.text = visitToBeUpdated?.vCommentary
            saveUpdateVisit.setTitle("Update", for: .normal)
        }
    }
    
    func setDate() -> String
    {
        let date = NSDate()
        var dateLoaded:String = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        dateLoaded = formatter.string(from:date as Date)
        return dateLoaded
    }
    
    func setTime() -> String
    {
        let date = NSDate()
        var timeLoaded:String = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        timeLoaded = formatter.string(from: date as Date)
        return timeLoaded
    }
    
    func configureDateTimePickers()
    {
        let loc = Locale(identifier: "us")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(VisitRegisterViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        //Start Date Configuration
        startdatePicker = UIDatePicker()
        startdatePicker?.datePickerMode = .date
        self.startdatePicker?.locale = loc
        startdatePicker?.addTarget(self, action: #selector(VisitRegisterViewController.startDateChanged(datePicker:)), for: .valueChanged)
        startDate.inputView = startdatePicker
        
        //Start Time Configuration
        startTimePicker = UIDatePicker()
        startTimePicker?.datePickerMode = .time
        self.startTimePicker?.locale = loc
        startTimePicker?.addTarget(self, action: #selector(VisitRegisterViewController.startTimeChanged(datePicker:)), for: .valueChanged)
        startTime.inputView = startTimePicker
        
        //End Date Configuration
        enddatePicker = UIDatePicker()
        enddatePicker?.datePickerMode = .date
        self.enddatePicker?.locale = loc
        enddatePicker?.addTarget(self, action: #selector(VisitRegisterViewController.endDateChanged(datePicker:)), for: .valueChanged)
        endDate.inputView = enddatePicker
        
        //End Time Configuration
        endtimePicker = UIDatePicker()
        endtimePicker?.datePickerMode = .time
        self.endtimePicker?.locale = loc
        endtimePicker?.addTarget(self, action: #selector(VisitRegisterViewController.endTimeChanged(datePicker:)), for: .valueChanged)
        endTime.inputView = endtimePicker
        
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    
    @objc func startDateChanged(datePicker: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        startDate.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func startTimeChanged(datePicker: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        startTime.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func endDateChanged(datePicker: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        endDate.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func endTimeChanged(datePicker: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        endTime.text = dateFormatter.string(from: datePicker.date)
    }

    
    //It saves the changes of the visit
    @IBAction func SaveChanges(_ sender: Any)
    {
        //Test TouristicPlace
        let tp = loadTouristicPlaceById(tpId: touristicPlaceSelectedId)
        let tpValidations = TPValidations()
        let validateString = tpValidations.validateVisitRegisterData((tp?.tpName!)!, startDate.text!, startTime.text!, endDate.text!,endTime.text!)
        if(!validateString.isEmpty)
        {
            showInfo(withTitle: "Error", withMessage: validateString)
        }
        else
        {
            let startDateTime = convertStringToDateTime(startDate.text!, startTime.text!)
            let endDateTime = convertStringToDateTime(endDate.text!, endTime.text!)
            let validateDateTime = tpValidations.validateVisitDateTime(startDateTime, endDateTime: endDateTime)
            if(!validateDateTime.isEmpty)
            {
                showInfo(withTitle: "Error", withMessage: validateDateTime)
            }
            else
            {
                if(visitTransactionMode == "INSERT")
                {
                    let lastVisitIdString = CoreDataStack.shared().getLastVisitId()
                    let nextVisitId = Int(lastVisitIdString)! + 1
                    let nextVisitIdString = String(nextVisitId)
                    _ = Visit(visitId: nextVisitIdString, touristicPlace: tp!, plannificationDateBegin: startDateTime, plannificationDateEnd: endDateTime, commentary: commentary.text!, context: CoreDataStack.shared().context)
                    save()
                    showInfoDismissViewController(withTitle: "Info", withMessage: "Data has been saved correctly.")
                }
                else
                {
                    if(visitTransactionMode == "UPDATE")
                    {
                        print("Entro aqui")
                        if let vs = loadVisitById(vId: (visitToBeUpdated?.vId)!)
                        {
                            print("Encontro para actualizar")
                            vs.setValue(tp, forKeyPath: "touristiPlaceVisit")
                            vs.setValue(startDateTime, forKeyPath: "vPlannificationDateBegin")
                            vs.setValue(endDateTime, forKeyPath: "vPlannificationDateEnd")
                            vs.setValue(commentary.text, forKeyPath: "vCommentary")
                            save()
                            showInfoDismissViewController(withTitle: "Info", withMessage: "Data has been updated correctly.")
                        }
                    }
                }
            }
        }
        
    }
    
    //It shows a message when the visit was created
    public func showInfoDismissViewController(withTitle: String = "Info", withMessage: String,action: (() -> Void)? = nil){
        performUIUpdatesOnMain
            {
                let ac = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default){ (action:UIAlertAction!) in
                    self.navigationController?.popViewController(animated: true)
                    
                }
                ac.addAction(OKAction)
                self.present(ac, animated: true,completion: nil)
        }
    }
    
    
    //It configures the touristic place pickerview
    func configureTouristicPlacePicker()
    {
        fetchData()
        pickerView.reloadAllComponents()
        touristicPlace.inputView = pickerView
    }
    
    //It fetchs the data of touristic places
    func fetchData()
    {
        var tps: [TouristicPlace]?
        do {
            try tps = CoreDataStack.shared().fetchAllTP(entityName: TouristicPlace.name)
        } catch {
            showInfo(withTitle: "Error", withMessage: "Error while fetching Pin locations: \(error)")
        }
        if(tps != nil)
        {
            print("Conteo de tps=\(String(describing: tps?.count))")
            touristicPlaces = tps!
        }
    }
}

//It loads the information of the touristic places set in the pickerview
extension VisitRegisterViewController:UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.fetchData()
        return touristicPlaces.count

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let oneData = touristicPlaces[row]
        return (oneData.tpName)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        touristicPlaceSelectedId = touristicPlaces[row].tpId!
        touristicPlace.text = touristicPlaces[row].tpName
    }
}
