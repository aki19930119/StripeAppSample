//
//  StripeRepository.swift
//  stripeAppSample
//
//  Created by 柿沼儀揚 on 2020/05/29.
//  Copyright © 2020 柿沼儀揚. All rights reserved.
//

import FirebaseFunctions

class StripeRepository {
    
    lazy var functions = Functions.functions()
    
    func createCustomerId(email: String, completion: ((String?, Error?) -> Void)?){
        let data: [String: Any] = [
            "email": email
        ]
        functions.httpsCallable("createStripeCustomer")
            .call(data) { result, error in

                if let error = error {
                    completion!(nil, error)
                } else if let data = result?.data as? [String: Any],
                    let customerId = data["customerId"] as? String {
                    completion!(customerId, nil)
                }
        }
    }
}
