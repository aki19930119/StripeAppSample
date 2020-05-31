//
//  stripeProvider.swift
//  stripeAppSample
//
//  Created by 柿沼儀揚 on 2020/05/29.
//  Copyright © 2020 柿沼儀揚. All rights reserved.
//

import Stripe
import Firebase
import FirebaseFunctions

import Stripe
import FirebaseFunctions

class StripeProvider: NSObject, STPCustomerEphemeralKeyProvider {
    lazy var functions = Functions.functions()
    let customerId: String
    
    init(customerId: String){
        self.customerId = customerId
    }
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let data: [String: Any] = [
            "customerId": customerId,
            "stripe_version": apiVersion
        ]
        functions
            .httpsCallable("createStripeEphemeralKeys")
            .call(data) { result, error in
                
                if let error = error {
                    completion(nil, error)
                } else if let data = result?.data as? [String: Any] {
                    completion(data, nil)
                }
        }
    }
}
