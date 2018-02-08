//
//  ATMBranchModel.swift
//  ATMBranchLocator
//
//  Created by Srinivas Kasanna on 2/6/18.
//  Copyright © 2018 asdf. All rights reserved.
//

import Foundation

struct ATMBranchModel : Codable{
    let errors: [mapError]
    let locations : [ATMBranchDetails]
}

struct mapError: Codable{
    let errorMessage: String?
    let errorCode: String?
}

struct ATMBranchDetails : Codable{
    let state : String
    let locType : String
    let label : String
    let address : String
    let city : String
    let zip : String
    let name : String
    let lat : String
    let lng : String
    let bank : String
    let type : String?
    let lobbyHrs : [String]?
    let driveUpHrs : [String]?
    let atms : Int?
    let services : [String]?
    let languages : [String]?
    let phone : String?
    let distance : Double
}

