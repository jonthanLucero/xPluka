//
//  VisitsListViewController.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/18/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import UIKit
import CoreData

class VisitListViewController: UIViewController {
    /// A table view that displays a list of visits
    @IBOutlet weak var tableView: UITableView!
    var viewControllerTitleForTransactionMode = ""
    var transactionMode = ""
    var visitToUpdate:Visit?
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Visit> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Visit> = Visit.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "vCreationDate", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared().context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self as NSFetchedResultsControllerDelegate
        
        return fetchedResultsController
    }()
    
    private func setupView() {
        updateView()
    }
    
    fileprivate func updateView() {
        var hasVisits = false
        
        if let visits = fetchedResultsController.fetchedObjects {
            hasVisits = visits.count > 0
        }
        
        tableView.isHidden = !hasVisits
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Visit Plannification"
        let tlabel = UILabel()
        tlabel.text = self.title
        tlabel.textColor = UIColor.white
        tlabel.font = UIFont(name: "Helvetica-Bold", size: 30.0)
        tlabel.backgroundColor = UIColor.clear
        tlabel.adjustsFontSizeToFitWidth = true
        tlabel.textAlignment = .center;
        self.navigationItem.titleView = tlabel
        
        
        self.setupView()
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        self.updateView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    @objc func applicationDidEnterBackground(_ notification: Notification) {
        do {
            try CoreDataStack.shared().context.save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
    }
    
    @IBAction func addVisit(_ sender: Any)
    {
        transactionMode = "INSERT"
        visitToUpdate = nil
        viewControllerTitleForTransactionMode = "Register Visit"
        performSegue(withIdentifier: "showVisitViewController", sender: nil)
    }
    
    @IBAction func showInfo(_ sender: Any) {
        var message = "\nIt allows to plannficate Visits by pressing in the + button.\n\n"
        message += "After the creation, it can be seen the plannification date with its icon.\n\n"
        message += "By sliding a visit in the list it appears a tag to delete it.\n\n"
        message += "By pressing in a visit, then it allows to update its information.\n"
        
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
        if segue.identifier == "showVisitViewController"
        {
            print("Segue loaded "+viewControllerTitleForTransactionMode)
            let controller = segue.destination as! VisitRegisterViewController
            controller.title = viewControllerTitleForTransactionMode
            controller.visitTransactionMode = transactionMode
            controller.visitToBeUpdated = visitToUpdate
        }
    }

}

extension VisitListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        updateView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            print("...")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
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

extension VisitListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let visits = fetchedResultsController.fetchedObjects else { return 0 }
        return visits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VisitTableViewCell.reuseIdentifier, for: indexPath) as? VisitTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        // Fetch Visit
        let visit = fetchedResultsController.object(at: indexPath)
        
        // Configure Cell
        let plannificationDateBegin = convertDateTimeToString(visit.vPlannificationDateBegin!,"E, MMM d HH:mm")
        let plannificationDateEnd = convertDateTimeToString(visit.vPlannificationDateEnd!,"E, MMM d HH:mm")
        let yearBegin = convertDateTimeToString(visit.vPlannificationDateBegin!, "yyyy")
        let yearEnd = convertDateTimeToString(visit.vPlannificationDateEnd!, "yyyy")
       
        cell.touristicPlaceName.adjustsFontSizeToFitWidth = true
        cell.touristicPlaceName.text = visit.touristiPlaceVisit?.tpName
        cell.touristicPlaceImageType.image = UIImage(named: loadImageMapName((visit.touristiPlaceVisit?.tpType!)!))
        cell.startDate.text = plannificationDateBegin
        cell.endDate.text = plannificationDateEnd
        cell.startYear.text = yearBegin
        cell.endYear.text = yearEnd
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Fetch Visit
            let visit = fetchedResultsController.object(at: indexPath)
            
            // Delete Visit
            CoreDataStack.shared().context.delete(visit)
            save()
        }
    }
}

extension VisitListViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // Fetch Visit
        visitToUpdate = fetchedResultsController.object(at: indexPath)
        transactionMode = "UPDATE"
        viewControllerTitleForTransactionMode = "Update Visit"
        performSegue(withIdentifier: "showVisitViewController", sender: nil)
    }
}
