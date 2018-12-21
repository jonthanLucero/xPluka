//
//  PhotoAlbumViewController.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/13/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, MKMapViewDelegate {
    
    //It declares the outlet controls used in the PhotoAlbumViewController
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout?
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelStatus: UILabel!
    
    //Variables for image gallery collection manipulation
    var selectedIndexes = [IndexPath]()
    var insertedIndexPaths: [IndexPath]!
    var deletedIndexPaths: [IndexPath]!
    var updatedIndexPaths: [IndexPath]!
    var totalPages: Int? = nil
    
    var presentingAlert = false
    var touristicPlace: TouristicPlace?
    var fetchedResultsController : NSFetchedResultsController<Photo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //it loads the default layout
        updateFlowLayout(view.frame.size)
        mapView.delegate = self
        //MapView zoom and scroll is enabled
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        
        //It loads by default status empty
        updateStatusLabel("")
        
        
        //It shows the pin location of the selected Touristic Place
        showOnTheMap(touristicPlace!)
        //It loads the information of the gallery set up in that pin
        setupFetchedResultControllerWith(touristicPlace!)
        
        //If there are no photos in that location, then it starts to search and download a photo gallery
        if let photos = touristicPlace?.photos, photos.count == 0 {
            // pin selected has no photos
            fetchPhotosFromAPI(touristicPlace!)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateFlowLayout(size)
    }
    
    //It deletes all photos from CoreData when user press new Gallery
    @IBAction func deleteAction(_ sender: Any) {
        // delete all photos
        for photos in fetchedResultsController.fetchedObjects! {
            CoreDataStack.shared().context.delete(photos)
        }
        save()
        fetchPhotosFromAPI(touristicPlace!)
    }
    
    private func setupFetchedResultControllerWith(_ tp: TouristicPlace) {
        
        let fr = NSFetchRequest<Photo>(entityName: Photo.name)
        fr.sortDescriptors = []
        //it loads the request to delete all the photos related to that pin
        fr.predicate = NSPredicate(format: "touristicPlacePhoto == %@", argumentArray: [tp])
        
        //It creates the fetchResultController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: CoreDataStack.shared().context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        // It starts looking for the photos related to that pin
        var error: NSError?
        do {
            try fetchedResultsController.performFetch()
        } catch let error1 as NSError {
            error = error1
        }
        
        if let error = error {
            print("\(#function) Error performing initial fetch: \(error)")
        }
    }
    
    //It searches new photos to the Flickr Site
    private func fetchPhotosFromAPI(_ tp: TouristicPlace) {
        
        let lat = Double(tp.tpLatitude!)!
        let lon = Double(tp.tpLongitude!)!
        
        activityIndicator.startAnimating()
        
        self.updateStatusLabel("Searching photos ...")
        
        //It begins searching new photos by using a request related to the Flickr API
        Client.shared().searchBy(latitude: lat, longitude: lon, totalPages: totalPages) { (photosParsed, error) in
            self.performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
                self.labelStatus.text = ""
            }
            //After the searching is finished then it evaluates if there are photos in the response or not
            if let photosParsed = photosParsed {
                self.totalPages = photosParsed.photos.pages
                let totalPhotos = photosParsed.photos.photo.count
                self.storePhotos(photosParsed.photos.photo, forTP: tp)
                if totalPhotos == 0 {
                    self.updateStatusLabel("No photos found for this location, Please use other location")
                }
                //If there was an error in the request to the server then it shows the status label with message
            } else if let error = error {
                print("\(#function) error:\(error)")
                self.showInfo(withTitle: "Error", withMessage: error.localizedDescription)
                self.updateStatusLabel("There was an error, please do it again some other time.")
            }
        }
    }
    
    //it updates the  status of the label
    private func updateStatusLabel(_ text: String) {
        self.performUIUpdatesOnMain {
            self.labelStatus.adjustsFontSizeToFitWidth = true
            self.labelStatus.text = text
        }
    }
    
    //it store the photos in the CoreData after they were downloaded
    private func storePhotos(_ photos: [PhotoParser], forTP: TouristicPlace) {
        func showErrorMessage(msg: String) {
            showInfo(withTitle: "Error", withMessage: msg)
        }
        
        for photo in photos {
            performUIUpdatesOnMain {
                if let url = photo.url {
                    _ = Photo(touristicPlace: forTP, title: photo.title, imageUrl: url, context: CoreDataStack.shared().context)
                    self.save()
                }
            }
        }
    }
    
    //It shows the pin location in the map
    private func showOnTheMap(_ tp: TouristicPlace) {
        
        let lat = Double(tp.tpLatitude!)!
        let lon = Double(tp.tpLongitude!)!
        let locCoord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locCoord
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
        mapView.setCenter(locCoord, animated: true)
    }
    
    
    //it loads the photos from the CoreData
    private func loadPhotos(using tp: TouristicPlace) -> [Photo]? {
        let predicate = NSPredicate(format: "touristicPlacePhoto == %@", argumentArray: [tp])
        var photos: [Photo]?
        do {
            try photos = CoreDataStack.shared().fetchPhotos(predicate, entityName: Photo.name)
        } catch {
            //it there was an error when getting the photos from DB, then show it.
            showInfo(withTitle: "Error", withMessage: "Error while lading Photos from disk: \(error)")
        }
        return photos
    }
    
    private func updateFlowLayout(_ withSize: CGSize) {
        
        let landscape = withSize.width > withSize.height
        
        let space: CGFloat = landscape ? 5 : 3
        let items: CGFloat = landscape ? 2 : 3
        
        let dimension = (withSize.width - ((items + 1) * space)) / items
        
        flowLayout?.minimumInteritemSpacing = space
        flowLayout?.minimumLineSpacing = space
        flowLayout?.itemSize = CGSize(width: dimension, height: dimension)
        flowLayout?.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    }
    
    //It shows a different message for the user to remove that photo or getting a new collection
    func updateBottomButton() {
        if selectedIndexes.count > 0 {
            button.setTitle("Remove Selected", for: .normal)
        } else {
            button.setTitle("New Collection", for: .normal)
        }
    }
}

extension PhotoAlbumViewController {
    //Method to show the behaviour in the map (red color, animated)
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
