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

## 🎨 Brand Palette

- **Primary (Bright Orange)**: `#FF6A1F`
- **Secondary (Black)**: `#121212`
- **Accent (Silver)**: `#C0C0C0`
- **Background/Neutral (White)**: `#FFFFFF`

### Gradient Options

- **Orange → Silver**: `linear-gradient(135deg, #FF6A1F 0%, #C0C0C0 100%)`
- **Black → Orange (Dark Mode)**: `linear-gradient(180deg, #121212 0%, #FF6A1F 100%)`
- **White → Silver (Light Mode)**: `linear-gradient(180deg, #FFFFFF 0%, #C0C0C0 100%)`

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

#### Connecting to a local backend
If you're running the API locally (for example at `http://localhost:8000`), set
the `BACKEND_URL` environment variable in the run scheme to the local URL. The
app will automatically use this value when built in Debug mode.

### Tests
The repository includes unit and UI tests. Run them from Xcode using **Product → Test**.


---

## 🤝 Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change. Make sure to update tests as appropriate.

---

## 📄 License
This project is licensed under the [MIT License](LICENSE).
