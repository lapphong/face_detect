# Face Detection

- App id: `com.buzzlp.jp`
- App name: `Face Detect`
- Flutter: stable `3.32.6`
- Dart sdk: `3.8.1`

- IDE:  Visual Code / Android Studio
- Deployment target
    - Android: `minSdkVersion 21`
    - iOS: `15.5+.`
- Device Orientation: Portrail (primary)
- Standard design: `Samsung Galaxy S22 (360x765 @3x)`

## 📸  Screenshots
<table>
  <tr>
    <th align="center">Demo</th>
    <th align="center">Front / Back</th>
  </tr>
  <tr>
    <td><img src="https://raw.githubusercontent.com/lapphong/face_detect/main/screenshots/video.gif" alt="Dash light" width="300"/></td>
    <td><img src="https://raw.githubusercontent.com/lapphong/face_detect/main/screenshots/demo.png" alt="Dash dark" width="300"/></td>
  </tr>
</table>

## **Technology stack details**

|Plugins|Description|
|:----|:----|
| State Management | [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) - Flutter Widgets that make it easy to implement the BLoC (Business Logic Component) design pattern. Built to be used with the bloc state management package. |
| Reactive programming | [`rx_dart`](https://pub.dev/packages/rxdart) - RxDart is an implementation of the popular reactiveX api for asynchronous programming, leveraging the native Dart Streams api. |
| Networking | [`dio`](https://pub.dev/packages/dio) - A powerful HTTP client for Dart, supporting interceptors, global configuration, FormData, request cancellation, and more. Ideal for RESTful API integration. |


## Features
 - [x] Face detection (front/back)
 - [x] Face size validation
 - [x] Offline data storage

## How to install Build

**Check build compile release:** <br>
 - iOS: `flutter build ios --no-codesign` <br>
 - Android: `flutter build apk --debug`

Issue iOS cache cocopod: `pod install --repo-update`
