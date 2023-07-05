SbuGrowはiOSの有料課金アプリにSDKを組み込んで使用して頂くフレームワークです。まずは当社サイトでアカウント登録をお願い致します。https://www.subgrow.jp
SDKを組み込むとこんなことが可能になります。(ENGLISH BELOW)

導入までの流れ：

![step1_ja](https://user-images.githubusercontent.com/88994667/156277531-a5a3fba0-97a7-4979-a810-c36fbfdc4b8d.png)

# 条件
SubGrowのSDKはiOS 12.3 と Swift version 5.0以降のバージョンでご使用頂けます。

# デモアプリ

デモアプリをインストールして頂くことで本サービスをテストできます。
ご質問がある際は info@subgrow.jp にご連絡下さい。
デモアプリをインストールした後、サブスクリプションのプランを選択して下さい。
サブスクリプションのプランを解約するにはiPhone→ プロフィール→サブスクリプション → 解約 の流れで解約できます。

https://testflight.apple.com/join/aF01qTu5

<img width="375" alt="Demo JP" src="https://user-images.githubusercontent.com/88994667/156279195-9bbd764f-5516-4ac0-a28e-8a8260eae4a0.png">

※本デモアプリではAppleのSANDBOXを利用しているため無料でサブスクリプション設定できるようになっています。

# インストール

現在 SubGrowのSDKはCocoaPods, Swift Package Managerまたは手動でインストール可能です。

# CocoaPodsでインストール
あなたのPodfileに下記ラインを組み込んでください。:
```sh
pod 'B2S'
```
# Swift Package Managerでインストール
package dependencyに下記URLを追加してください。:
```sh
https://github.com
```
# 手動でインストール
SubGrowフォルダから全てのファイルをコピーし、こちらのリンク(link)からあなたのプロジェクト(アプリ)にファイルをペーストして下さい。 [link](https://github.com/Subgrow/SubGrowSDK).
# SDKの初期化
SubGrownを初期化するにはSDKキーが必要です。SubGrowを組み込んでいるあなたのアプリを識別するユニークなIDになります。SDKキーはイニシャライゼーション内のあなたのアカウントから取り出すことができます。詳しくはこちらを参照ください。:
```sh 
import B2S

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  ...
  B2S.shared.configure(sdkKey: "Your_SDK_Key")
  ...
  return true
}
```

こちらが有料課金プランを解約したユーザーを呼び戻す方法です。プロモーションを使用してサブスクリプションを再度購入するとSubGrowのデリゲートメソッドが呼び出されます。: 

```sh 
extension MainViewController: B2SDelegate {
    func b2sPromotionOfferDidPurchase(productId: String, offerId: String, transaction: SKPaymentTransaction) {
        // Deliver content from server, aaply subscription and then call: SKPaymentQueue.default().finishTransaction(transaction) unless you do it elsewhere
    }
}
```
# ENGLISH 

SubGrow SDK is a framework that makes implementing in-app subscriptions in iOS. 
First, you need to register in our site https://www.subgrow.jp

What we do?

![workflow](https://user-images.githubusercontent.com/88994667/158531074-40c00ae0-79a6-4851-aaf7-25b90d86d4a4.png)

# Requirements
SubGrow SDK requires minimum iOS 12.3 and Swift version 5.0.

# Demo app
You can install and test our Demo app and check how the service works, if you have any question, feel free to write to us info@subgrow.jp

After installing demo app, you can subscribe in a subscription plan like 1 month plan for 5 min. To unsubscribe, you need to go settings on your iPhone→ profile→subscription →and unsubscribe there.

https://testflight.apple.com/join/aF01qTu5

![Demo](https://user-images.githubusercontent.com/88994667/158531407-324855a6-46c3-46d1-b600-cb44ec581f44.png)

*We will not charge you, we use Apple SANDBOX in this app.

# Installation
Currently, SubGrow SDK can be installed via CocoaPods, Swift Package Manager or manually.

# Install via CocoaPods
Add the following line to your Podfile
```sh
pod 'Subgrow'
```
# Install via Swift Package Manager
Add package dependency with the following URL:
```sh
https://github.com/SubGrow/SubGrowSDK
```
# Manual Installation
Copy all files from SubGrow folder.And paste to your project(application) from this [link](https://github.com/SubGrow/SubGrowSDK).
# Initialise SDK
To initialize SubGrow SDK, you will need SDK Key. It is a unique identifier of your application that connects to SubGrow service . You can take SDK Key from your account in a Basic initialization.
Also you can set checkAndShowOfferAtStart parameter if you want to see the offer screen after application launch (set true) or not (set false). By default it is true. Here is more detail:

```sh 
import Subgrow

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  ...
  B2S.shared.configure(sdkKey: "Your_SDK_Key") // offer will be showed by default OR put B2S.shared.configure(sdkKey: "Your_SDK_Key", checkAndShowOfferAtStart: false) if you don't want to see the offer
  ...
  return true
}
```
You can get available offer when you want. In this case you just have to import SDK and call the checkAndShowOffer function:

```sh 
import Subgrow

class ABC {
...
B2S.shared.checkAndShowOffer()
...
}
```

If you want to have push notification -> you have to send to SDK your device token:

```sh 
import Subgrow

class AppDelegate {
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    ...
    B2S.shared.setPushToken(deviceToken)
    ...
  }
}
```

This is what you need to return unsubscribe users. When a user purchased subscription through promotion offer, the SubGrow delegate method will be called:: 

```sh 
extension MainViewController: B2SDelegate {
    func b2sPromotionOfferDidPurchase(productId: String, offerId: String, transaction: SKPaymentTransaction) {
        // Deliver content from server, aaply subscription and then call: SKPaymentQueue.default().finishTransaction(transaction) unless you do it elsewhere
    }
}
```
