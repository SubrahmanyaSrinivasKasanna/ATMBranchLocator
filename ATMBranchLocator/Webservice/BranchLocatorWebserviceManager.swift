//
//  BranchLocatorWebserviceManager.swift
//  ATMBranchLocator
//
//  Created by Srinivas Kasanna on 2/6/18.
//  Copyright © 2018 asdf. All rights reserved.
//

import UIKit

struct BranchLocatorWebserviceManager{

    //This method will create api url with latitude and longitude.
    static func getLocationServiceURL(lat:String, lon:String) -> URL? {
        return URL(string: "\(ATM_FINDER_URL)lat=\(lat)&lng=\(lon)")
    }
    
    static func getNearByATMsandBranches(latitude: String, longtude: String, completionHandler:@escaping ((_ branchsList:ATMBranchModel?)->Void)){
        
        guard let locationServiceURL = getLocationServiceURL(lat: latitude, lon: longtude) else{
            print("Invalid URL")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: locationServiceURL) { (data, response, error) in
            guard let res = response else{return}
            #if DEBUG
                print(res)
            #endif
            guard let data = data else{
                print("Invalid response")
                return
            }
            do{
                let jsonStr = try JSONDecoder().decode(ATMBranchModel.self, from: data)
                if jsonStr.errors.count == 0 {
                    DispatchQueue.main.async {
                        completionHandler(jsonStr)
                    }
                }
            }catch{
                print(error)
            }
        }
        task.resume()
    }
    
}
