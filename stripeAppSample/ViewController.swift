//
//  ViewController.swift
//  stripeAppSample
//
//  Created by 柿沼儀揚 on 2020/05/29.
//  Copyright © 2020 柿沼儀揚. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFirestore


class ViewController: UIViewController {
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var chooseButton: UIButton!
    
    private var paymentContext: STPPaymentContext?
    
    @IBAction func stripeButtonTapped(_ sender: Any) {
        let customerId = "cus_HSSpOSharNnoFh"
        let customerContext = STPCustomerContext(keyProvider: StripeProvider(customerId: customerId))
        paymentContext = STPPaymentContext(customerContext: customerContext)
        paymentContext!.delegate = self
        paymentContext!.hostViewController = self
//        paymentContext!.paymentAmount = 5000
        paymentContext!.presentPaymentOptionsViewController()
        
    }
    
    
    @IBAction func payButtonTapped(_ sender: Any) {
        paymentContext?.requestPayment()

    }
}

extension ViewController: STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        print("paymentContextDidChange")
        cardNameLabel.text = paymentContext.selectedPaymentOption?.label
        cardImageView.image = paymentContext.selectedPaymentOption?.image

    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        print(paymentContext)
        print("paymentContext")
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        print("STPPaymentResult")
        print(paymentContext)
        
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        print("STPPaymentStatus")
        
    }

}
