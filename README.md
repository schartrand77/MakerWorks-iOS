# 👑 MakerWorks iOS

[![Build](https://img.shields.io/badge/build-passing-brightgreen?style=flat-square)]()
[![Platform](https://img.shields.io/badge/platform-iOS-blue?style=flat-square)]()
[![License](https://img.shields.io/badge/license-MIT-lightgrey?style=flat-square)]()
[![App Store](https://img.shields.io/badge/app%20store-coming%20soon-orange?style=flat-square)]()

> 🛠️ *The iOS app for makers who want more than another sad STL viewer.*

MakerWorks iOS is a **next-gen app for browsing, hosting, and managing 3D models — with payments, uploads, and a sleek, glassy UI that's actually pleasant to use.** It's fast, modern, and it makes your models look great.

---

## ✨ Features

- 🌐 Browse MakerWorks-hosted 3D models in a blazing-fast gallery.
- 📤 Upload STL & 3MF models directly from your device.
- 🖼️ Auto-generated thumbnails & metadata extraction.
- 💳 Integrated payments — no awkward side-payments or emailing strangers.
- 📋 Manage your account & uploads with a VisionOS-inspired dashboard.
- 🌓 Dark & light modes included.
- 🪞 Liquid Glass UI: clean, modern, and ridiculously polished.

---

## 📸 Screenshots

| 📱 Home | 📤 Upload | 💳 Payments |
|--------|----------|---------|
| ![Home](assets/screenshots/home.png) | ![Upload](assets/screenshots/upload.png) | ![Payments](assets/screenshots/payments.png) |

> *Replace the images in `assets/screenshots/` with real screenshots when ready.*

---

## 🧪 Tech Stack

- 🎯 **Swift + SwiftUI**
- 🍎 iOS 17+
- 🔄 Combine
- 🧼 Clean architecture
- 🎨 VisionOS-inspired design language

---

## 🚀 Getting Started

### Requirements
- macOS with Xcode 15+
- iOS 17+ Simulator or Device

### Installation
```bash
git clone https://github.com/schartrand77/MakerWorks-iOS.git
cd MakerWorks-iOS
open MakerWorks.xcodeproj
```

### Running
1. Select the `MakerWorks` scheme in Xcode.
2. Choose an iOS simulator or connect a device.
3. Press **Run** to build and launch the app.

### Tests
The repository includes unit and UI tests. Run them from Xcode with **Product → Test**.
After installing the Swift toolchain (see below), you can also execute the tests
from the command line with:

```bash
swift test
```

### CLI Setup (Swift Package Manager)

To run the tests outside of Xcode you need a Swift toolchain with the Swift
Package Manager. A helper script is provided for Ubuntu 20.04+:

```bash
sudo ./scripts/install_swift.sh
```

Once installation completes, open a new terminal (to update your `PATH`) and
verify Swift is available:

```bash
swift --version
```

You can then execute the tests using `swift test` as shown above.

---

## 🤝 Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change. Make sure to update tests as appropriate.

---

## 📄 License
This project is licensed under the [MIT License](LICENSE).
