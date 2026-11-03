# Buildr Test iOS App

A minimal iOS test application for validating the Buildr System's iOS deployment pipeline.

## Overview

This is a simple SwiftUI app that displays a success message and build information. It's designed to test:
- Xcode project configuration
- Fastlane integration
- GitHub Actions CI/CD
- TestFlight deployment
- App Store Connect integration

## Project Structure

```
buildr-test-ios/
├── buildr-test-ios.xcodeproj/     # Xcode project
├── buildr-test-ios/               # Source code
│   ├── buildr_test_iosApp.swift   # App entry point
│   ├── ContentView.swift          # Main UI
│   ├── Assets.xcassets/           # App icon and assets
│   └── Info.plist                 # App configuration
├── buildr.yaml                    # Buildr configuration
├── Fastfile                       # Fastlane automation
├── .github/workflows/             # GitHub Actions CI/CD
│   └── ios-deploy.yml
└── project.yml                    # XcodeGen configuration
```

## App Features

The app displays:
- ✅ Green checkmark icon
- 📱 "Buildr Test" title
- 📝 "iOS deployment successful!" message
- 🔢 Current build number from bundle

## Configuration

### Bundle Identifier
`com.rosinante.buildr-test-ios`

### Minimum iOS Version
iOS 15.0

### Build Settings
- Version: 1.0
- Build: 1 (auto-incremented by Fastlane)
- Swift Version: 5.0
- Supports: iPhone and iPad

## Local Testing

### Prerequisites
- macOS with Xcode 15+
- Apple Developer Account
- Fastlane installed: `gem install fastlane`

### Build Locally

```bash
# Open in Xcode
open buildr-test-ios.xcodeproj

# Or build from command line
xcodebuild -project buildr-test-ios.xcodeproj \
  -scheme buildr-test-ios \
  -configuration Release \
  -destination 'generic/platform=iOS'
```

### Test in Simulator

```bash
# Run in iPhone 15 simulator
xcodebuild -project buildr-test-ios.xcodeproj \
  -scheme buildr-test-ios \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  build
```

## Deployment

### Manual Deployment Steps

See [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md) for detailed manual testing steps.

### GitHub Actions Deployment

See [GITHUB_SECRETS_SETUP.md](GITHUB_SECRETS_SETUP.md) for required secrets configuration.

Once secrets are configured:
- Push to `develop` branch → TestFlight upload
- Push to `main` branch → App Store upload (manual submission)

## Testing Report

See [TEST_REPORT.md](TEST_REPORT.md) for test results and status.

## Documentation

- **BUILD_INSTRUCTIONS.md** - Manual build and deployment steps
- **GITHUB_SECRETS_SETUP.md** - GitHub Actions secrets configuration
- **TEST_REPORT.md** - Testing status and results
- **buildr.yaml** - Buildr System configuration

## Support

For issues with:
- **Buildr System**: Check `/Users/rosinante/Projects/Buildr-System/IOS_TROUBLESHOOTING.md`
- **Xcode**: See Apple's Xcode documentation
- **Fastlane**: Visit https://docs.fastlane.tools/

## License

MIT License - Created for Buildr System testing purposes.
