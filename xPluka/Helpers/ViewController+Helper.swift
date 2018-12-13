//
//  ViewController+Helper.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/11/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import UIKit

extension UIViewController
{
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //it saves the context of the App for further CoreData use
    func save(){
        do {
            try CoreDataStack.shared().saveContext()
        }
        catch
        {
            showInfo(withTitle: "Error", withMessage: "Error while saving Pin location: \(error)")
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
}
