//
//  ApiRequest.swift
//  Autonomous Vehicle App
//
//  Created by Ben Gilliam, JMU '18 on 2/13/18.
//

import Foundation

class ApiRequest {
    
    func getApiData() {
        guard let url = URL(string: "https://753f23f7-21dd-4d0a-95c9-9248f64ab854.mock.pstmn.io/V1/locations") else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            
            if let data = data {
                print(data)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
                
            }
            }.resume()
    }
}
