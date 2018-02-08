//
//  ATMBranchLocatorTests.swift
//  ATMBranchLocatorTests
//
//  Created by Srinivas Kasanna on 2/6/18.
//  Copyright © 2018 asdf. All rights reserved.
//

import XCTest
@testable import ATMBranchLocator

let branchLocatorStoryboard = "Main"

// I can improve Unit test cases if I would get time to work for this app
class ATMBranchLocatorTests: XCTestCase {
    
    var branchDetailsVC:BranchLocatorDetailsViewController!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        guard let vc1 = BranchLocatorUtils.loadVCFromStoryboard(storyboard: branchLocatorStoryboard, vcIdentifier: "branchDetailsViewControllerID") as? BranchLocatorDetailsViewController else {
            XCTFail("VC is nil")
            return
        }
        self.branchDetailsVC = vc1
        let branchDetails = ATMBranchDetails.init(state: "TX", locType: "branch", label: "Valley Ranch", address: "8585 N Macarthur Blvd", city: "Irving", zip: "75063", name: "Valley Ranch", lat: "32.923337", lng: "-96.955992", bank: "Chase", type: "Freestanding", lobbyHrs: ["9:00-6:00"], driveUpHrs: ["8:00-6:00"], atms: 8, services: [], languages: [], phone: "9729109803", distance: 1.1)
        self.branchDetailsVC.branchATMInfo = branchDetails

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.branchDetailsVC = nil

        super.tearDown()
    }
    
    func testLocatorViewControllerOutlets() {
        guard let vc = BranchLocatorUtils.loadVCFromStoryboard(storyboard: branchLocatorStoryboard, vcIdentifier: "branchLocatorViewController") as? BranchLocatorViewController else {
            XCTFail("VC is nil")
            return
        }
        XCTAssertNotNil(vc.view)
    }
    
    func testLocationsWebServiceValidResponse() {
        
        //Hardcoded lat, longs
        let lat = "32.936631399561"
        let long = "-96.9458751368348"
        
        let exp = expectation(description:"LocationServiceExpectation")
        BranchLocatorWebserviceManager.getNearByATMsandBranches(latitude: lat, longtude: long, completionHandler: {(branchsList:ATMBranchModel?)-> Void in
            XCTAssertNotNil(branchsList, "Location service returned empty response")
            XCTAssert(branchsList?.locations.count != 0, "Location service returned invalid response zero locations")
            exp.fulfill()
        })
        waitForExpectations(timeout: 100, handler: { error in
            print("No reposne")
        })
    }

    func testLocationsWebServiceInvalidResponse() {

        //Hardcoded lat, longs
        let lat = "0"
        let long = "0"
        
        let exp = expectation(description:"LocationServiceExpectation")
        BranchLocatorWebserviceManager.getNearByATMsandBranches(latitude: lat, longtude: long, completionHandler: {(branchsList:ATMBranchModel?)-> Void in
            XCTAssertNotNil(branchsList, "Location service returned empty response")
            XCTAssert(branchsList?.locations.count == 0, "Location service returned invalid response")
            exp.fulfill()
        })
        waitForExpectations(timeout: 100, handler: { error in
            print("No reposne")
        })
    }
    
    func testBranchATMDetailsVCOutlets() {
        _ = self.branchDetailsVC?.view
        XCTAssertNotNil(self.branchDetailsVC.branchAddress)
        XCTAssertNotNil(self.branchDetailsVC.branchDistance)
        XCTAssertNotNil(self.branchDetailsVC.branchPhoneNumber)
        XCTAssertNotNil(self.branchDetailsVC.branchPhoneNumberTitle)
        XCTAssertNotNil(self.branchDetailsVC.branchPhoneNumberCallButton)
        XCTAssertNotNil(self.branchDetailsVC.mapView)
    }
    
    func testGetDirectionsandCallToBranch(){
        _ = self.branchDetailsVC?.view
        self.branchDetailsVC.callToPhoneNumber()
        self.branchDetailsVC.openMapsWithDirectionToBranchATM()
        self.branchDetailsVC.openDirections(UIButton())
        
    }
    
    func testIfPhoneCallOptionAvailableForValidPhoneNumber() {
        let branchDetails = ATMBranchDetails.init(state: "TX", locType: "branch", label: "Valley Ranch", address: "8585 N Macarthur Blvd", city: "Irving", zip: "75063", name: "Valley Ranch", lat: "32.923337", lng: "-96.955992", bank: "Chase", type: "Freestanding", lobbyHrs: ["9:00-6:00"], driveUpHrs: ["8:00-6:00"], atms: 8, services: [], languages: [], phone: "9729109803", distance: 1.1)
        self.branchDetailsVC.branchATMInfo = branchDetails
        _ = self.branchDetailsVC?.view
        XCTAssert(!self.branchDetailsVC.branchPhoneNumberCallButton.isHidden)
    }

    func testIfPhoneCallOptionAvailableForInvalidPhoneNumber() {
        let branchDetails = ATMBranchDetails.init(state: "TX", locType: "branch", label: "Valley Ranch", address: "8585 N Macarthur Blvd", city: "Irving", zip: "75063", name: "Valley Ranch", lat: "32.923337", lng: "-96.955992", bank: "Chase", type: "Freestanding", lobbyHrs: ["9:00-6:00"], driveUpHrs: ["8:00-6:00"], atms: 8, services: [], languages: [], phone: "", distance: 1.1)
        self.branchDetailsVC.branchATMInfo = branchDetails
        _ = self.branchDetailsVC?.view
        XCTAssert(self.branchDetailsVC.branchPhoneNumberCallButton.isHidden)
    }
}
