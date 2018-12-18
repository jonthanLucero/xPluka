//
//  tpRegister.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/6/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import Foundation
import UIKit

protocol TPRegisterViewControllerPassDataBackward
{
    func isReloadMap(_ mapStatus:Bool)
}


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
    @IBOutlet weak var tpShowGallery: UIButton!
    @IBOutlet weak var tpDeleteTP: UIButton!
    
    var delegate:TPRegisterViewControllerPassDataBackward?

    var tpLatitudeReceived:String=""
    var tpLongitudeReceived:String=""
    var tpTransactionMode:String=""
    var tpNameLoaded:String=""
    var tpTouristicPlace:TouristicPlace? = nil
    var deleteStatus:String = ""
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        tpLatitude.text = tpLatitudeReceived
        tpLongitude.text = tpLongitudeReceived
        
        print("parametros recibidos="+tpTransactionMode)
        self.hideKeyboardWhenTappedAround()
        tpShowGallery.isEnabled = true
        if(tpTransactionMode == "INSERT")
        {
            tpShowGallery.isEnabled = false
            tpDeleteTP.isHidden = true
        }
        
        if(tpTransactionMode == "UPDATE")
        {
            print("Datos tp recibidos")
            print("nombre "+(tpTouristicPlace?.tpName!)!)
            print("latitud "+(tpTouristicPlace?.tpLatitude!)!)
            print("longitud "+(tpTouristicPlace?.tpLongitude!)!)
            
            tpName.text = tpTouristicPlace?.tpName
            tpDescription.text = tpTouristicPlace?.tpDescription
            tpType.text =  tpTouristicPlace?.tpType
            tpLatitude.text = tpTouristicPlace?.tpLatitude
            tpLongitude.text = tpTouristicPlace?.tpLongitude
            tpQualification.text = tpTouristicPlace?.tpQualification
            tpObservations.text =  tpTouristicPlace?.tpCommentary
        }
    }

    @IBAction func tpShowImageGallery(_ sender: Any)
    {
        //It shows the PhotoAlbumViewController where it displays the photo gallery.
        print("Data to send to ShowPhotoGallery")
        print("tpName Photo "+(tpTouristicPlace?.tpName)!)
        print("tpLatitude Photo "+(tpTouristicPlace?.tpLatitude)!)
        print("tpLongitude Photo"+(tpTouristicPlace?.tpLongitude)!)
        performSegue(withIdentifier: "showPhotoGallerySegue", sender: tpTouristicPlace)
    }
    
    //It allows to save or update the content of the Touristic Place
    @IBAction func tpSaveChanges(_ sender: Any) {
        let tpValidations = TPValidations()
        let validateString = tpValidations.validateTPRegisterData(tpName.text!, tpDescription.text!, tpType.text!, tpQualification.text!)
        if(!validateString.isEmpty)
        {
            showInfo(withTitle: "Error", withMessage: validateString)
        }
        else
        {
            if(!tpValidations.validateTPType(tpType.text!))
            {
                showInfo(withTitle: "Error", withMessage: "Type of Touristic Place is not valid.")
            }
            else
            {
                if(!tpValidations.validateTPQualification(Int(tpQualification.text!)!))
                {
                    showInfo(withTitle: "Error", withMessage: "Qualification is not valid.")
                }
                else
                {
                    if (tpTransactionMode == "INSERT")
                    {
                        _ = TouristicPlace(name: tpName.text!, description: tpDescription.text!, type: tpType.text!, latitude: tpLatitude.text!, longitude: tpLongitude.text!, qualification: tpQualification.text!, commentary: tpObservations.text!, context: CoreDataStack.shared().context)
                        save()
                        if(validateTPInsertData(tpName.text!, tpLatitude.text!, tpLongitude.text!))
                        {
                            showInfoDismissViewController(withTitle: "Info", withMessage: "Data has been saved correctly.")
                        }
                        else
                        {
                            showInfo(withTitle: "Error", withMessage: "Data was not saved.")
                        }
                    }
                    else
                    {
                        if(tpTransactionMode == "UPDATE")
                        {
                            if let tp = loadTouristicPlace(latitude: tpLatitude.text!, longitude: tpLongitude.text!)
                            {
                                tp.setValue(tpName.text!, forKeyPath: "tpName")
                                tp.setValue(tpDescription.text!, forKeyPath: "tpDescription")
                                tp.setValue(tpType.text!, forKeyPath: "tpType")
                                tp.setValue(tpLatitude.text!, forKeyPath: "tpLatitude")
                                tp.setValue(tpLongitude.text!, forKeyPath: "tpLongitude")
                                tp.setValue(tpQualification.text!, forKeyPath: "tpQualification")
                                tp.setValue(tpObservations.text!, forKeyPath: "tpCommentary")
                                save()
                                showInfoDismissViewController(withTitle: "Info", withMessage: "Data has been updated correctly.")
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func tpDeleteTPChanges(_ sender: Any) {
        deleteStatus = "YES"
        showInfoDeleteDismissViewController(withMessage: "Do you wish to delete this Touristic Place")
    }
    
    //It checks if the Touristic Place was saved correctly
    func validateTPInsertData(_ name: String, _ latitude: String, _ longitude: String) -> Bool
    {
        var validateStatus:Bool = false
        let predicate = NSPredicate(format:"tpName == %@ AND tpLatitude == %@ AND tpLongitude== %@",name,latitude,longitude)
        do{
            try _ = CoreDataStack.shared().fetchTP(predicate, entityName: TouristicPlace.name)
            validateStatus = true
        }
        catch{
            validateStatus = false
        }
        return validateStatus
    }
    
    //It opens the TPRegisterViewController where the touristic place is registered(NEW)
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotoGallerySegue"
        {
            guard let tp = sender as? TouristicPlace else {
                return
            }
            let controller = segue.destination as! PhotoAlbumViewController
            controller.tp  = tp
        }
    }
    
    //it shows a message to warn the user of any issue or complete process.
    public func showInfoDeleteDismissViewController(withTitle: String = "Info", withMessage: String,action: (() -> Void)? = nil){
        performUIUpdatesOnMain
        {
            let ac = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            {
                (action:UIAlertAction!) in
                //let tpNameDeleted = self.tpTouristicPlace?.tpName
                let tpLatitudeDeleted = self.tpTouristicPlace?.tpLatitude
                let tpLongitudeDeleted = self.tpTouristicPlace?.tpLongitude
                
                print("Va a borrar un tp")
                if let tp = self.loadTouristicPlace(latitude: tpLatitudeDeleted!,longitude: tpLongitudeDeleted!)
                {
                    print("Encontro el tp para borrar")
                    CoreDataStack.shared().context.delete(tp)
                    self.save()
                    
                    self.showInfo(withMessage: "Touristic Place has been deleted.")
                    self.navigationController?.popViewController(animated: true)
                }
            }
            ac.addAction(OKAction)
            
            let CancelAction = UIAlertAction(title:"CANCEL",style: .cancel){(action:UIAlertAction!) in
                print("CancelActionPressed")
            }
            ac.addAction(CancelAction)
            self.present(ac, animated: true,completion: nil)
        }
    }
    
    public func showInfoDismissViewController(withTitle: String = "Info", withMessage: String,action: (() -> Void)? = nil){
        performUIUpdatesOnMain
            {
                let ac = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default){ (action:UIAlertAction!) in
                self.delegate?.isReloadMap(true)
                self.navigationController?.popViewController(animated: true)
                
                }
                ac.addAction(OKAction)
                self.present(ac, animated: true,completion: nil)
        }
    }
    
}
