//
//  StripeRepository.swift
//  stripeAppSample
//
//  Created by 柿沼儀揚 on 2020/05/29.
//  Copyright © 2020 柿沼儀揚. All rights reserved.
//

import Hydra
import FirebaseFunctions

//デバイスライブラリのエラー定義。
enum ClientError: LocalizedError {
    case noData
    case cast
}

//Stripeの保管場所
class StripeRepository {
    lazy var functions = Functions.functions()
    //CustomerIdの作成
    func createCustomerId(email: String) -> Promise<String> {
        //resolve 解決　reject　拒否する
        return Promise<String> (in: .background, { resolve, reject, _ in
            let data: [String: Any] = [
                "email": email
            ]
            self.functions.httpsCallable("createStripeCustomer")
                .call(data) { result, error in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        reject(error)
                    } else if let data = result?.data as? [String: Any],
                        let customerId = data["customerId"] as? String {
                        resolve(customerId)
                    } else {
                        reject(ClientError.noData)
                    
                    }
            }
        })
    }
    
    //Chargeの作成
    func createCharge(customerId: String, sourceId: String, amount: Int) -> Promise<Void> {
        return Promise<Void> (in: .background, { resolve, reject, _ in
            let data: [String: Any] = [
                "customerId": customerId,
                "sourceId": sourceId,
                "amount": amount,
                //ユニークIDの設定
                "idempotencyKey": UUID().uuidString
            ]
            self.functions.httpsCallable("createStripeCharge")
                .call(data) { result, error in
                    
                    if let error = error {
                        reject(error)
                    } else {
                        resolve(())
                    }
            }
        })
    }
}
