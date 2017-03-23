//
//  NetworkRequest.swift
//  medication-reminder
//
//  Created by Marc Santos on 2017-03-21.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum NetworkRequestType: String {
    case POST = "POST",
    GET = "GET",
    PUT = "PUT",
    PATCH = "PATCH"
}

class NetworkRequest {
    
    static let apiBaseUrl = "http://localhost:9000/api/"
    
    class func createRequest(requestType: NetworkRequestType, url: String, data: [[String:Any]]?, queryParameters: Parameters?) -> URLRequest? {
        
        guard let url = URL(string: url) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue

        //Set header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let data = data {
            do {
                request.httpBody  = try JSONSerialization.data(withJSONObject: data, options: [])
            }
            catch {
                print("[ERROR]Could not serialize body to JSON")
            }
        }
        
        if let queryParameters = queryParameters {
            do {
                request = try URLEncoding.queryString.encode(request, with: queryParameters)
            }  catch {
                print("[ERROR]Failed to encode request with query")
            }
        }
        
        return request
    }
    
    class func getMedications(startDate: Date, endDate: Date, successHandler: @escaping (JSON) -> Void) {
        if startDate > endDate {
            print("Failed to get medications because start date is greater than end date")
            return
        }
        
        let calendar = Calendar.current
        let start = calendar.toString(date: startDate)
        let end = calendar.toString(date: endDate)
        let url = "\(apiBaseUrl)medications"
        let queryParameters: Parameters = [
            "start": start,
            "end": end
        ]
        
        
        guard let request = createRequest(requestType: .GET, url: url, data: nil, queryParameters: queryParameters) else {
            print("Failed to make get medication URLRequest")
            return
        }
        
        Alamofire.request(request).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                successHandler(json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    class func patchMedication(medicationId: String, params: [String: Any], successHandler: @escaping (JSON) -> Void) {
        
        let url = "\(apiBaseUrl)medications/\(medicationId)"

        guard let request = createRequest(requestType: .PATCH, url: url, data: [params], queryParameters: nil) else {
            print("Unable to create request for PATCH medication with id \(medicationId)")
            return
        }
        
        Alamofire.request(request).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                successHandler(json)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
}

