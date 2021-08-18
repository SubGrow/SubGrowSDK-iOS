//
//  IAPHandler.swift
//
//  Created by Pramod Kumar on 13/07/2017.
//  Copyright © 2017 Pramod Kumar. All rights reserved.
//
import UIKit
import StoreKit

enum IAPHandlerAlertType {
    case setProductIds
    case disabled
    case restored
    case purchased
    case purchaseFailed(error: SKError)

    var message: String{
        switch self {
        case .setProductIds: return "Product ids not set, call setProductIds method!"
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        case .purchaseFailed: return "Product purchase failed"
        }
    }
}


class IAPHandler: NSObject {
    
    //MARK:- Shared Object
    //MARK:-
    static let shared = IAPHandler()
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    //MARK:- Properties
    //MARK:- Private
    fileprivate var productIds = [String]()
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var fetchProductcompletion: (([SKProduct])->Void)?
    
    fileprivate var productToPurchase: SKProduct?
    fileprivate var purchaseProductCompletion: ((IAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)?
    
    //MARK:- Public
    var isLogEnabled: Bool = true
    
    //MARK:- Methods
    //MARK:- Public
    
    //Set Product Ids
    func setProductIds(ids: [String]) {
        self.productIds = ids
    }

    //MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchase(product: SKProduct, discount: SKPaymentDiscount?, completion: @escaping ((IAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)) {
        
        self.purchaseProductCompletion = completion
        self.productToPurchase = product

        if self.canMakePurchases() {
            let payment = SKMutablePayment(product: product)
            payment.paymentDiscount = discount
            payment.applicationUsername = ""
            SKPaymentQueue.default().add(payment)
            
            log("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
        }
        else {
            completion(IAPHandlerAlertType.disabled, nil, nil)
        }
    }
    
    // RESTORE PURCHASE
    func restorePurchase(){
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(completion: @escaping (([SKProduct])->Void)){
        
        self.fetchProductcompletion = completion
        // Put here your IAP Products ID's
        if self.productIds.isEmpty {
            log(IAPHandlerAlertType.setProductIds.message)
            fatalError(IAPHandlerAlertType.setProductIds.message)
        }
        else {
            productsRequest = SKProductsRequest(productIdentifiers: Set(self.productIds))
            productsRequest.delegate = self
            productsRequest.start()
        }
    }
    
    //MARK:- Private
    fileprivate func log <T> (_ object: T) {
        if isLogEnabled {
            NSLog("\(object)")
        }
    }
}

//MARK:- Product Request Delegate and Payment Transaction Methods
//MARK:-
extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    // REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        fetchProductcompletion?(response.products)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if let completion = self.purchaseProductCompletion {
            completion(IAPHandlerAlertType.restored, nil, nil)
        }
    }
    
    // IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        let purchasedTransactions = transactions.filter { $0.transactionState == .purchased }
        purchasedTransactions.forEach {
            PurchaseAPI.sendPurchase(transactionId: $0.original?.transactionIdentifier ?? "") { response in
                print()
            }
        }
        guard productToPurchase != nil else { return }
        transactions.forEach { transaction in
            switch transaction.transactionState {
            case .purchased:
                log("Product purchase done")
                purchaseProductCompletion?(IAPHandlerAlertType.purchased, self.productToPurchase, transaction)
            case .failed:
                let error: SKError = transaction.error as? SKError ?? SKError(.unknown)
                purchaseProductCompletion?(IAPHandlerAlertType.purchaseFailed(error: error), self.productToPurchase, transaction)
                log("Product purchase failed")
            case .restored:
                log("Product restored")
            default:
                return
            }
//            SKPaymentQueue.default().finishTransaction(transaction)
        }
    }
}
