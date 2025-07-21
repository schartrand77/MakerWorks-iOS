# MakerWorks iOS

MakerWorks-iOS is a SwiftUI application for interacting with the MakerWorks service. The project contains network clients, view models, and views for authentication, browsing models, requesting estimates, uploading prints, and managing local favorites.

The app communicates with the MakerWorks backend at `https://api.makerworks.app` by default. You can update the base URL programmatically via `DefaultNetworkClient` if needed.

## Async Networking
`DefaultNetworkClient` now includes `async/await` APIs for performing requests. These helpers let you integrate with Swift's modern concurrency features without relying on Combine publishers.


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

## Favorites
Models can be marked as favorites locally. Use the star button on a model card to toggle the favorite state. The **Favorites** tab lists all favorited models.

## Beta Testing
To distribute beta builds via TestFlight:
1. In Xcode, select the Release configuration and choose **Any iOS Device (arm64)** as the run destination.
2. Choose **Product > Archive** to generate an archive of the app.
3. Create an App Store Connect record for the bundle identifier or add a new version if one already exists.
4. Upload the archive from the Organizer to App Store Connect.
5. Once processing is complete, add testers and distribute the build through TestFlight.


Testers should install the TestFlight app from the App Store and accept the invitation with their Apple ID. Beta builds expire after 90 days.
You'll need a distribution provisioning profile (or automatic signing) to upload archives, and any development devices must be registered with your Apple developer team.

## License
This project is available under the [MIT License](LICENSE).
