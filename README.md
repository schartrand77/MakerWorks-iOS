# MakerWorks iOS

MakerWorks-iOS is a SwiftUI application for interacting with the MakerWorks service. The project contains network clients, view models, and views for authentication, browsing models, requesting estimates, and uploading prints.

## Prerequisites
- macOS with [Xcode](https://developer.apple.com/xcode/) **16.3** or later
- A valid Apple development account to run on devices

## Build and Run
1. Open `MakerWorks.xcodeproj` in Xcode.
2. Select the `MakerWorks` target and your preferred simulator or device.
3. Build and run the app with **Cmd+R** or by pressing the Run button.

Alternatively, use `xcodebuild` on the command line:
```sh
xcodebuild -scheme MakerWorks -destination 'platform=iOS Simulator,name=iPhone 15' build
```

## Running Tests
The project includes unit and UI tests. You can run them from Xcode using the Test action (**Cmd+U**).

To run the tests from the command line:
```sh
xcodebuild -scheme MakerWorks -destination 'platform=iOS Simulator,name=iPhone 15' test
```
