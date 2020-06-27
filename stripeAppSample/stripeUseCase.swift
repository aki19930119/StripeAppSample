//
//  stripeUseCase.swift
//  stripeAppSample
//
//  Created by 柿沼儀揚 on 2020/06/14.
//  Copyright © 2020 柿沼儀揚. All rights reserved.
//

import Hydra

//Stripeを使うための箱
class StripeUseCase {
    //クラスStripeRepositoryの呼びだし
    private let stripeRepo = StripeRepository()
    
    //StripeのCustomerIdを作成
    private func createStripeCustomerId(email: String) -> Promise<String> {
        return stripeRepo.createCustomerId(email: email)
    }
    
    func charge(sourceId: String, amount: Int) -> Promise<Void> {
        //customerIdの取得
        guard let customerId = UserDataStore.getString(.stripeCustomerId) else {
            //エラーなら拒否されたエラーの表示
            return Promise<Void>.init(rejected: ClientError.cast)
        }
        return stripeRepo.createCharge(customerId: customerId, sourceId: sourceId, amount: amount)
    }
}
