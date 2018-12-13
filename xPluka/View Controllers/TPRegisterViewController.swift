//
//  tpRegister.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/6/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import Foundation
import UIKit

public class TPRegisterViewController: UIViewController
{
    //Declaration of variables to use the controls
    @IBOutlet weak var tpName: UITextField!
    @IBOutlet weak var tpDescription: UITextField!
    @IBOutlet weak var tpType: UITextField!
    @IBOutlet weak var tpLatitude: UITextField!
    @IBOutlet weak var tpLongitude: UITextField!
    @IBOutlet weak var tpQualification: UITextField!
    @IBOutlet weak var tpObservations: UITextField!
    @IBOutlet weak var tpShowLocation: UIButton!
    
    var tpLatitudeReceived:String=""
    var tpLongitudeReceived:String=""
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tpShowLocation.isHidden = true
        tpLatitude.text = tpLatitudeReceived
        tpLongitude.text = tpLongitudeReceived
    }

    @IBAction func tpShowLocation(_ sender: Any)
    {
        
    }
    
    @IBAction func tpShowImageGallery(_ sender: Any)
    {
        
    }
    
    //It allows to save or update the content of the Touristic Place
    @IBAction func tpSaveChanges(_ sender: Any) {
        let validateString = validateTPRegisterData()
        if(!validateString.isEmpty)
        {
            showInfo(withTitle: "Error", withMessage: validateString)
        }
        else
        {
            _ = TouristicPlace(name: tpName.text!, description: tpDescription.text!, type: tpType.text!, latitude: tpLatitude.text!, longitude: tpLongitude.text!, qualification: tpQualification.text!, commentary: tpObservations.text!, context: CoreDataStack.shared().context)
            save()
            showInfo(withTitle: "Info", withMessage: "Data has been saved correctly.")
        }
    }
    
    //Validates if there are required data not filled
    func validateTPRegisterData() -> String
    {
        var errorMessage:String = ""
        
        if (self.tpName.text?.isEmpty)!
        {
            errorMessage="Name"
        }
        
        if (self.tpDescription.text?.isEmpty)!
        {
            errorMessage+=",Description"
        }
        
        if (self.tpType.text?.isEmpty)!
        {
            errorMessage+=",Type"
        }
        
        if (self.tpQualification.text?.isEmpty)!
        {
            errorMessage+=",Qualification"
        }
        
        if(!errorMessage.isEmpty)
        {
            errorMessage+=" required."
        }
        
        return errorMessage
        
    }
    
    func validateTPInsertData() -> Bool
    {
        let validateStatus:Bool = false
        
        
        
        return validateStatus
    }
    
    
    
}
