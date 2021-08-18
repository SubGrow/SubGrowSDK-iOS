//
//  StoreService.swift
//  B2S
//
//  Created by Egor Sakhabaev on 07.07.2021.
//

import Foundation
import StoreKit
struct StoreService {
    static func purchasePromotionOffer(productId: String, offerId: String) -> Promise<SKPaymentTransaction> {
        IAPHandler.shared.setProductIds(ids: [productId])
        var purchasingProduct: SKProduct?
        let promise = fetchProduct(id: productId)
            .then { product -> Promise<DiscountSignature> in
                purchasingProduct = product
                return signDiscount(offerId: offerId)
            }.then { signature -> Promise<SKPaymentTransaction> in
                let discount = SKPaymentDiscount.init(identifier: signature.offerId,
                                                      keyIdentifier: signature.keyId,
                                                      nonce: UUID(uuidString: signature.nonce)!,
                                                      signature: signature.sign,
                                                      timestamp: .init(value: signature.timeStamp))
                return purchase(product: purchasingProduct!, discount: discount)
            }
        return promise
    }
    
    static func fetchProduct(id: String) -> Promise<SKProduct> {
        return .init { fulfill, reject in
            IAPHandler.shared.setProductIds(ids: [id])
            IAPHandler.shared.fetchAvailableProducts { products in
                guard let product = products.first(where: { $0.productIdentifier == id }) else {
                    reject(InternalError.unknownError)
                    return
                }
                fulfill(product)
            }
        }
    }
    
    static func signDiscount(offerId: String) -> Promise<DiscountSignature> {
        return .init { fulfill, reject in
            OfferAPI.signDiscount(offerId: offerId) { response in
                switch response {
                case .Success(let responseData):
                    guard let data = try? JSONSerialization.data(withJSONObject: responseData, options: []),
                          let signature = try? JSONDecoder().decode(DiscountSignature.self, from: data) else {
                        reject(InternalError.unknownError)
                        return
                    }
                    fulfill(signature)
                case .Error(let error):
                    reject(error)
                }
            }
        }
    }
    
    static func purchase(product: SKProduct, discount: SKPaymentDiscount?) -> Promise<SKPaymentTransaction> {
        return .init { fulfill, reject in
            IAPHandler.shared.purchase(product: product, discount: discount) { type, product, transaction in
                if case .purchased = type, let transaction = transaction {
                    fulfill(transaction)
                } else if case .purchaseFailed(let error) = type {
                    reject(error)
                } else {
                    reject(SKError(.unknown))
                }
            }
        }
    }
}
