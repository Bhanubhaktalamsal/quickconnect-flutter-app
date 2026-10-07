# QuickConnect Flutter App

A Flutter implementation of the supplied QuickConnect UI:

- Quick Menu
- Diagnose Internet
- Request Connection
- WiFi Analyzer
- Visit Website
- New Connection map
- Current GPS location
- Address selection by tapping the map
- Name / mobile / email / address form
- Installation Request / Service Expansion Request
- Send Request validation and submission placeholder

## 1. Install Flutter

Install Flutter and Android Studio, then verify:

```bash
flutter doctor
```

## 2. Create / open the project

This folder is already a Flutter project source. Open it in VS Code or Android Studio.

Run:

```bash
flutter pub get
flutter run
```

## 3. Android location permission

The Android manifest already includes:

- ACCESS_FINE_LOCATION
- ACCESS_COARSE_LOCATION
- INTERNET

For Android, enable Location/GPS on the phone when testing the "current location" button.

## 4. GitHub — first time

Create an empty repository on GitHub, for example:

`quickconnect-flutter-app`

Then from this project folder:

```bash
git init
git add .
git commit -m "Initial QuickConnect Flutter app"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/quickconnect-flutter-app.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username.

## 5. Later updates

After changing code:

```bash
git add .
git commit -m "Update QuickConnect app"
git push
```

## 6. Important: connect the Send Request button to your backend

Currently `sendRequest()` validates the form and prints the request to the debug console.

Replace the marked section in `lib/main.dart` with your real API/Firebase request.

Suggested data sent to backend:

```json
{
  "name": "Customer Name",
  "mobile": "98XXXXXXXX",
  "email": "customer@example.com",
  "address": "Customer address",
  "requestType": "Installation Request",
  "latitude": 28.600000,
  "longitude": 81.630000
}
```

## 7. Map

This version uses OpenStreetMap tiles through `flutter_map`.

For a production application, review OpenStreetMap tile usage requirements or use a suitable commercial/self-hosted tile provider.

## 8. Build Android APK

```bash
flutter build apk --release
```

The APK will be generated under:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## 9. Recommended next development

1. Add your company logo.
2. Add your real website URL.
3. Connect Send Request to your NMS/CRM/API.
4. Save customer requests in a database.
5. Add login/authentication if required.
6. Add real WiFi diagnostics.
7. Add ticket creation and ticket status.
