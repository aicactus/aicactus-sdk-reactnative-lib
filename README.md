# AicactusSDK React Native (IOS/ANDROID)

AicactusSDK is a client side module for AiCactus platform.

Analytics helps you measure your users, product, and business. It unlocks insights into your app's funnel, core business metrics, and whether you have product-market fit.

## Installation

```bash
$ yarn add @tvpsoft/aicactus-sdk-react-native
$ cd ios && pod install && cd .. # CocoaPods on iOS
```

## Usage

<!-- prettier-ignore -->
```js
import aicactusSDK from '@tvpsoft/aicactus-sdk-react-native'

aicactusSDK
    .setup('writeKey', {
        recordScreenViews: true,
        trackAppLifecycleEvents: true,
        android: {
            flushInterval: 60000,
            collectDeviceId: true
        },
        ios: {
            trackAdvertising: true,
            trackDeepLinks: true
        }
    })
    .then(() =>
        console.log('AicactusSDK is ready')
    )
    .catch(err =>
        console.error('Something went wrong', err)
    );

aicactusSDK.track('Watch video');
aicactusSDK.screen('Home');
```



## Troubleshooting (just in case 😅)
### "Failed to load [...] native module"

If you're getting a `Failed to load [...] native module` error, it means that some native code hasn't been injected to your native project.

#### iOS

If you're using Cocoapods, check that your `ios/Podfile` file contains the right pods :

- `Failed to load Analytics native module`, look for the core native module:
  ```ruby
  pod 'RNAnalytics', :path => '../node_modules/@tvpsoft/aicactus-sdk-react-native'
  ```

Also check that your `Podfile` is synchronized with your workspace, run `pod install` in your `ios` folder.

If you're not using Cocoapods please check that you followed the [iOS support without CocoaPods](#ios-support-without-cocoapods) instructions carefully.

#### Android

Check that `android/app/src/main/.../MainApplication.java` contains a reference to the native module:

- `Failed to load Analytics native module`, look for the core native module:

  ```java
  import io.aicactus.sdk.reactnative.core.RNAnalyticsPackage;

  // ...

  @Override
  protected List<ReactPackage> getPackages() {
      return Arrays.<ReactPackage>asList(
          new MainReactPackage(),
          // ...
          new RNAnalyticsPackage()
      );
  }
  ```
