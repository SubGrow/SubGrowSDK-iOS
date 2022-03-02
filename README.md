BackToSubscribtion SDK is an framework that makes implementing in-app subscriptions in iOS. (!!!ENGLISH BELOW!!!)

First you need to register in our site https://www.backtosub.jp

Please check documents how to implements our SDK and how to use it [link](https://docs.backtosub.jp).

How it works?

![step1_ja](https://user-images.githubusercontent.com/88994667/156277531-a5a3fba0-97a7-4979-a810-c36fbfdc4b8d.png)

# Requirements
B2S SDK requires minimum iOS 12.3 and Swift version 5.0.

# Demo app
You can install and test our Demo app and test how service works, if you have any qustion please wite to us info@backtosub.com

After install demo app you can subscribe in subscribtion plan which 1 month = 5 min, to unsubscribe you need to go settings on your iPhone, profile, subscribtion and unsubscribe there.

https://testflight.apple.com/join/2jiV70RP

<img width="375" alt="Demo JP" src="https://user-images.githubusercontent.com/88994667/156279195-9bbd764f-5516-4ac0-a28e-8a8260eae4a0.png">

*it will not charge you real money, we use Apple SANDBOX in this app.

# Installation
B2S SDK currently can be installed via CocoaPods, Swift Package Manager or manually.
# Install via CocoaPods
Add the following line to your Podfile:
```sh
pod 'B2S'
```
# Install via Swift Package Manager
Add package dependency with the following URL:
```sh
https://github.com/BackToTheSubscription/B2S
```
# Manual Installation
Copy all files from B2S folder to your project from this [link](https://github.com/BackToTheSubscription/B2S).
# Initialise SDK
To initialise B2S SDK you will need SDK Key. It is a unique identifier of your B2S application. Мы можете взять его из вашего приложения в личном кабинете
Basic initialisation looks like this:
```sh 
import B2S

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  ...
  B2S.shared.configure(sdkKey: "Your_SDK_Key")
  ...
  return true
}
```

This what you need that B2S starts to return unsubscribe users.
When a user makes a purchase of a subscription through a promotion offer, the B2SDelegate method will be called: 

```sh 
extension MainViewController: B2SDelegate {
    func b2sPromotionOfferDidPurchase(productId: String, offerId: String, transaction: SKPaymentTransaction) {
        // Deliver content from server, aaply subscription and then call: SKPaymentQueue.default().finishTransaction(transaction) unless you do it elsewhere
    }
}
```
