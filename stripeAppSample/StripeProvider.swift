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

//Stripeとの接続クラス
class StripeProvider: NSObject, STPCustomerEphemeralKeyProvider {
    //呼ばれるまで初期化処理が走らない
    lazy var functions = Functions.functions()
    let customerId: String
    //インスタンス(実体)を初期化
    init(customerId: String){
        self.customerId = customerId
    }
    
    //CustomerKeyの作成
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let data: [String: Any] = [
            "customerId": customerId,
            "stripe_version": apiVersion
        ]
        //tsのcreateStripeEphemeralKeysと連携  関数の呼び出し
        functions
            .httpsCallable("createStripeEphemeralKeys")
            .call(data) { result, error in
                
                if let error = error {
                    //エラーの概要の表示
                    print(error.localizedDescription)
                    //functionsが完了してエラーだったらnilとerrorを返す
                    completion(nil, error)
                } else if let data = result?.data as? [String: Any] {
                    //ちゃんと帰ってきたらdataとnilを返す
                    completion(data, nil)
                }
        }
    }
}
