//
//  BranchLocatorDetailsViewController.swift
//  ATMBranchLocator
//
//  Created by Srinivas Kasanna on 2/6/18.
//  Copyright © 2018 asdf. All rights reserved.
//

import UIKit
import MapKit
import Contacts


class BranchLocatorDetailsViewController: UIViewController {
    var branchATMInfo: ATMBranchDetails!

    @IBOutlet var branchAddress: UILabel!
    @IBOutlet var branchDistance: UILabel!
    @IBOutlet var branchPhoneNumber: UILabel!
    @IBOutlet var branchPhoneNumberTitle: UILabel!
    @IBOutlet var branchPhoneNumberCallButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!

    //MARK:- View controller overriden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = branchATMInfo.name
        self.markSelectedBranchATMInMap()
        self.setupScreenData()
    }
    
    //MARK:- Action methods
    /**
     * To call to ATM/Branch phone number
     */
    @IBAction func callToPhoneNumber(){
        if let phone = branchATMInfo.phone {
            BranchLocatorUtils.callToNumber(phoneNum: phone)
        }
    }
    //MARK:- InstanceMethods
    /**
     * To display user selected ATM/Branch in map view
     */
    func markSelectedBranchATMInMap(){
        guard let selectedBranchLatitude = Double(branchATMInfo.lat) else {
            print("latitude is nil")
            return
        }
        guard let selectedBranchLongitude = Double(branchATMInfo.lng) else {
            print("longitude is nil")
            return
        }
        let CLLCoordType = CLLocationCoordinate2D(latitude: selectedBranchLatitude,
                                                  longitude: selectedBranchLongitude)
        let anno = MKPointAnnotation()
        anno.coordinate = CLLCoordType
        mapView.addAnnotation(anno)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(CLLCoordType,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)

    }
    /**
     * To display user selected ATM/Branch info in screen
     */
    func setupScreenData(){
        self.branchAddress.text = "\(branchATMInfo.address),\n\(branchATMInfo.city),\(branchATMInfo.state) \(branchATMInfo.zip)"
        self.branchDistance.text = "\(branchATMInfo.distance) Mile(s)"
        guard let phoneNumber = branchATMInfo.phone, phoneNumber != "" else{
            self.branchPhoneNumberCallButton.isHidden = true
            return
        }
        self.branchPhoneNumberTitle.text = BRANCH_DETAILS_PHONE_TITLE
        self.branchPhoneNumber.text = phoneNumber
    }


    /**
     * To show leaving app popup when user selects open diretions
     */
    @IBAction func openDirections(_ sender: UIButton?) {
        
        let message = "To view \(branchATMInfo.address) in Apple Maps."
        
        let alertController = UIAlertController(title: APP_LEAVE_ALERT_TITLE, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: STRING_LABEL_ALERT_OK, style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            self.openMapsWithDirectionToBranchATM()
        }
        let cancelAction = UIAlertAction(title: STRING_LABEL_ALERT_CANCEL, style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    /**
     * To open maps to show directions to seleted ATM/Branch
     */
    func openMapsWithDirectionToBranchATM() {
        guard let selectedBranchLatitude = Double(branchATMInfo.lat) else {
            print("latitude is nil")
            return
        }
        guard let selectedBranchLongitude = Double(branchATMInfo.lng) else {
            print("longitude is nil")
            return
        }

        let CLLCoordType = CLLocationCoordinate2D(latitude: selectedBranchLatitude,
                                                  longitude: selectedBranchLongitude)

        var placemark:MKPlacemark
        placemark = MKPlacemark(coordinate: CLLCoordType, addressDictionary: [CNPostalAddressStreetKey as String: branchATMInfo.address, CNPostalAddressCityKey as String: branchATMInfo.city, CNPostalAddressStateKey as String: branchATMInfo.state, CNPostalAddressPostalCodeKey as String: branchATMInfo.zip])
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.phoneNumber = branchATMInfo.phone
        mapItem.name = branchATMInfo.name
        
        var mapItems = [MKMapItem]()
        mapItems.append(mapItem)
        
        MKMapItem.openMaps(with: mapItems, launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }

}
