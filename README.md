# Requirements
B2S SDK requires minimum iOS 12.3 and Swift version 5.0.
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
Это все что вам нужно, чтобы B2S начал возвращать отписавшихся.

Когда пользователь совершит покупку подписки через promotion offer вызовится метод B2SDelegate:

```sh 
extension MainViewController: B2SDelegate {
    func b2sPromotionOfferDidPurchase(productId: String, offerId: String, transaction: SKPaymentTransaction) {
        // Deliver content from server, aaply subscription and then call: SKPaymentQueue.default().finishTransaction(transaction) unless you do it elsewhere
    }
}
```
