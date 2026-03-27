# 🛍️ ShopVault

> A full-featured **Flutter e-commerce app** with Firebase authentication, AI-powered smart search, and a clean modern UI.

---

## ✨ Features

### 🔐 Authentication
- Email & Password Sign In / Sign Up
- Google Sign In
- Forgot Password (email reset)
- Firebase Auth integration

### 🏠 Home
- Personalized greeting with user name
- Live Flash Deals countdown timer ⏱️
- Banner carousel with smooth page indicators
- Category filter (Electronics, Fashion, Home & Garden, Beauty)
- Flash Deals & Popular Products sections

### 🤖 AI Smart Search
- Tap ✨ to activate AI-powered search
- Understands Arabic & English queries
- Semantic matching — search "هدية للأم" and find relevant products
- Smart scoring system ranks results by relevance

### 🛒 Cart
- Add / remove products
- Quantity control with swipe-to-delete
- Real-time subtotal, shipping, and total calculation

### ❤️ Wishlist
- Add / remove from any product screen
- Grid view with quick Add to Cart

### 💳 Checkout
- 3-step flow: Shipping → Payment → Review
- Multiple payment methods (Card, PayPal, Cash on Delivery)
- Order success screen

### 👤 Profile & Settings
- Edit profile (name, phone, date of birth) — saves to Firebase
- Dark / Light mode toggle
- My Orders with tracking timeline (Active / Completed / Cancelled)
- Shipping Addresses management
- Payment Methods with card UI
- Coupons (Available / Used tabs)
- Help, About, Settings pages

### 🔔 Notifications
- Read / Unread state
- Order updates, flash sale alerts, coupons

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter |
| State Management | Flutter BLoC (Cubit) |
| Authentication | Firebase Auth |
| Architecture | Feature-Based Clean Architecture |
| UI | Google Fonts, Gap, Custom Theme Extension |
| Search | AI Smart Search (semantic scoring engine) |

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── cubits/
│   │   ├── cart/
│   │   ├── wishlist/
│   │   └── theme/
│   ├── services/
│   │   └── auth_service.dart
│   └── theme/
│       ├── app_colors.dart
│       └── theme_extension.dart
├── features/
│   ├── Home/
│   ├── Search/          ← AI Smart Search
│   ├── ProductDetails/
│   ├── Cart/
│   ├── Wishlist/
│   ├── Checkout/
│   ├── Orders/
│   ├── Profile/
│   ├── Settings/
│   ├── Notifications/
│   ├── Addresses/
│   ├── Payment/
│   ├── Coupons/
│   ├── LoginView/
│   ├── SignUp/
│   ├── OnboardingView/
│   └── SplashView/
└── main.dart
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Firebase project configured

### Installation

```bash
# Clone the repo
git clone https://github.com/Mohandshraf/ShopValut.git

# Navigate to project
cd ShopValut

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Firebase Setup
1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable **Authentication** (Email/Password + Google)
3. Download `google-services.json` → place in `android/app/`
4. Download `GoogleService-Info.plist` → place in `ios/Runner/`

---

## 📦 Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.x        # State management
  firebase_core: ^3.x       # Firebase core
  firebase_auth: ^5.x       # Authentication
  google_sign_in: ^6.x      # Google Sign In
  google_fonts: ^6.x        # Typography
  gap: ^3.x                 # Spacing utility
  device_preview: ^1.x      # Device preview
```

---

## 🎨 Design Highlights

- **Color palette:** Warm gold (`#D4A574`), Forest green (`#2D6A4F`), Clean whites & deep darks
- **Typography:** Playfair Display (headings) + Outfit (body) + Cairo (Arabic text)
- **Dark mode:** Full dark/light theme support with smooth toggle
- **Animations:** Animated banners, countdown timers, smooth page transitions

---

## 👨‍💻 Author

**Mohand Ashraf**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat&logo=linkedin)](https://linkedin.com/in/mohandashraf)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black?style=flat&logo=github)](https://github.com/Mohandshraf)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

⭐ **If you found this project helpful, please give it a star!**
