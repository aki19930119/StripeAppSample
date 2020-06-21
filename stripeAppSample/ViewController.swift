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
import Firebase

private let useCase = StripeUseCase()

class ViewController: UIViewController {
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var chooseButton: UIButton!
    
    private var paymentContext: STPPaymentContext?
    
    private let useCase = StripeUseCase()
    private let striperepo = StripeRepository()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "ポイント"
    }
    
    @IBAction func stripeButtonTapped(_ sender: Any) {
        //        let customerId = "cus_HSSpOSharNnoFh"
        let customerId = "cus_HSSpOSharNnoFh"
        
        //        let customerId = Firestore.firestore().collection("users").whereField("customeId", isEqualTo: "cus_HSSpOSharNnoFh")
        //        let customerId = Firestore.firestore().collection("users").document("nV352O4aCH6Egv5WtV4n")
        
        //        customerId.getDocument { (document, error) in
        //            if let document = document, document.exists {
        //                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
        //                print("Document data: \(dataDescription)")
        //            } else {
        //                print("Document does not exist")
        //            }
        //        }
        print("customerId")
        print(customerId)
        
        //        guard let customerId = UserDataStore.getString(.stripeCustomerId) else {
        //            return
        //        }
        
        let customerContext = STPCustomerContext(keyProvider: StripeProvider(customerId: customerId))
        paymentContext = STPPaymentContext(customerContext: customerContext)
        paymentContext!.delegate = self
        paymentContext!.hostViewController = self
        paymentContext!.paymentAmount = 5000
        paymentContext!.presentPaymentOptionsViewController()
        
    }
    
    
    @IBAction func payButtonTapped(_ sender: Any) {
        paymentContext?.requestPayment()
        
    }
}
    extension ViewController: STPPaymentContextDelegate {
        func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
            cardNameLabel.text = paymentContext.selectedPaymentOption?.label
            cardImageView.image = paymentContext.selectedPaymentOption?.image
            
        }
        
        func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
            print(paymentContext)
            print("paymentContext")
            
        }
        
        func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
            print("STPPaymentResult")
            

            let sourceId = charge(paymentResult.sources.stripeID)
            let paymentAmount = paymentContext.paymentAmount
            useCase
                .charge(sourceId: sourceId, amount: paymentAmount)
                .then {
                    completion(nil)
            }.catch { error in
                completion(error)
            }
            
        }
        
        func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
            print("didFinishWith")
            
            switch status {
            case .error:
                self.showErrorDialog(error!)
            case .success:
                self.showOKDialog(title: "決済に成功しました")
            case .userCancellation:
                break
            @unknown default:
                break
            }
            print(status)
        }
    }
    
    extension ViewController {
        func showOKDialog(title: String, message: String? = nil, ok: String = "OK", completion: (() -> Void)? = nil){
            DispatchQueue.main.async {
                let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: ok, style: .default, handler: { _ in
                    completion?()
                })
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        func showErrorDialog(_ error: Error, completion: (() -> Void)? = nil){
            DispatchQueue.main.async {
                let alert = UIAlertController(title: error.localizedDescription,
                                              message: nil, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    completion?()
                })
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
}
