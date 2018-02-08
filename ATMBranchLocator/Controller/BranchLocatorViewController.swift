//
//  BranchLocatorViewController.swift
//  ATMBranchLocator
//
//  Created by Srinivas Kasanna on 2/6/18.
//  Copyright © 2018 asdf. All rights reserved.
//

import UIKit
import GoogleMaps

class BranchLocatorViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate  {

    let locationManager = CLLocationManager()
    let currentLocation = CLLocation()
    var mapView: GMSMapView!
    var branchATMList: [ATMBranchDetails]?
    
    //MARK:- View controller overriden methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        self.title = BRANCH_LOCATOR_SCREEN_TITLE
        self.navigationController?.navigationBar.backItem?.title = " "

        //Request authorization from the user to access the location.
        locationManager.requestAlwaysAuthorization()
        //Request authorization from the user to use in foreground
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        // Check location authorization status and show alert in case of not authorized yet

        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted{
                BranchLocatorUtils.showAlert(controller: self, title: LOCATION_SERVICE_DISABLE_ALERT_TITLE, message: LOCATION_SERVICE_DISABLE_ALERT_MESSAGE)
            }
        }
    }

    //MARK: CLLocationManagerDelegate methods.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            markCurrentLocation()
            if let currentLocationCoords: CLLocationCoordinate2D = manager.location?.coordinate{
                #if DEBUG
                    print("locations = \(currentLocationCoords.latitude) \(currentLocationCoords.longitude)")
                #endif
                BranchLocatorWebserviceManager.getNearByATMsandBranches(latitude: "\(currentLocationCoords.latitude)", longtude: "\(currentLocationCoords.longitude)", completionHandler: {(branchsList:ATMBranchModel?)-> Void in
                    self.branchATMList = branchsList?.locations
                    self.plotBranchesAndATMs()
                })
            }
        }
    }

    /**
     * Plot ATM locations as PINs on the map view
     */
    func plotBranchesAndATMs() -> Void {
        if let branchATMList = self.branchATMList{
            var bounds = GMSCoordinateBounds()
            for branchATMInfo in branchATMList{
                //Set the marker in provided location co-ordinates
                guard let branchInfoLat = Double(branchATMInfo.lat), let branchInfoLong = Double(branchATMInfo.lng) else{
                    return
                }
                let position = CLLocationCoordinate2D(latitude: branchInfoLat, longitude: branchInfoLong)
                let marker = GMSMarker(position: position)
                marker.title = branchATMInfo.name
                marker.snippet = "\((branchATMInfo.locType == "atm") ? "ATM" : "Financial Center")\n\(branchATMInfo.distance) Mile(s)"
                marker.icon = UIImage(named: (branchATMInfo.locType == "atm") ? "atm" : "branch")
                marker.map = self.mapView
                bounds = bounds.includingCoordinate(marker.position)
            }
            let update = GMSCameraUpdate.fit(bounds, withPadding: 25)
            self.mapView.animate(with: update)
        }
    }
    
    //MARK:- GoogleMap Delegate Methods
    /**
     * Called after a marker's info window has been tapped.
     */
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        if let selectedATMBranchDetails = self.branchATMList?.filter({
            if let lat = Double($0.lat), let long = Double($0.lng){
                return (lat == marker.position.latitude && long == marker.position.longitude)
            }
            return false
        }), selectedATMBranchDetails.count > 0{
            guard let selectedBranchInfo = selectedATMBranchDetails.first else{
                return
            }
            self.navigateToBranchDetailsScene(with: selectedBranchInfo)
        }
    }
    
    
    //MARK:- InstanceMethods
    /**
     * To display user current location in Google maps
     */
    func markCurrentLocation() {
        //Set the location coordinates in the GMAP
        guard let currentLocationLatitude = self.locationManager.location?.coordinate.latitude else {
            print("latitude is nil")
            return
        }
        guard let currentLocationLongitude = self.locationManager.location?.coordinate.longitude else {
            print("longitude is nil")
            return
        }
        //Set the current location in Google Maps
        let camera = GMSCameraPosition.camera(withLatitude: currentLocationLatitude, longitude: currentLocationLongitude, zoom: 10)
        //Set the frame including origin location and location co-ordinates
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.settings.myLocationButton=true
        mapView.isMyLocationEnabled=true
        self.mapView.delegate = self
        //Set the google map to the view in root view controller view controller
        self.view = mapView
        let locationCoordinate = CLLocationCoordinate2DMake(currentLocationLatitude, currentLocationLongitude)
        let marker = GMSMarker(position: locationCoordinate)
        marker.appearAnimation = .pop
        marker.title = "You're Here"
        marker.map = mapView
        self.mapView.setMinZoom(4, maxZoom: 16)
    }

    /**
     * To navigate to Branch details view controller
     */
    func navigateToBranchDetailsScene(with atmBranchDetails:ATMBranchDetails){
        let storyBoard = UIStoryboard(name: MAIN_STORYBOARD, bundle: Bundle.main)
        guard let branchDetailsViewController = storyBoard.instantiateViewController(withIdentifier: BRANCH_DETAILS_VIEW_CONTROLLER_ID) as? BranchLocatorDetailsViewController else{
            print("Unable to instantiate BranchLocatorDetailsViewController object")
            return
        }
        branchDetailsViewController.branchATMInfo = atmBranchDetails
        self.navigationController?.pushViewController(branchDetailsViewController, animated: true)
    }

}

