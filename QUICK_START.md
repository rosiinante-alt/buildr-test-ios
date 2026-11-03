# Quick Start - Buildr iOS Test App

**Repository:** https://github.com/rosiinante-alt/buildr-test-ios  
**Status:** ✅ Ready for Testing

---

## Test in Simulator (No Credentials Needed) - 5 Minutes

```bash
cd /Users/rosinante/Projects/buildr-test-ios
open buildr-test-ios.xcodeproj

# In Xcode:
# 1. Select "iPhone 15" simulator from device dropdown
# 2. Press ⌘R (or Product → Run)
# 3. Verify app displays correctly
```

**Expected result:** Green checkmark, "Buildr Test" title, success message

---

## Deploy to TestFlight (Requires Apple Developer) - 1 Hour

### Prerequisites
- Apple Developer Account ($99/year)
- Xcode configured with Apple ID

### Steps

**1. Configure Xcode (5 min)**
```bash
# Open Xcode → Settings → Accounts
# Add your Apple ID
# Note your Team ID (ABC123XYZ format)
```

**2. Update Configuration (2 min)**
```bash
# Edit buildr.yaml, line 14:
team_id: YOUR_TEAM_ID_HERE
```

**3. Create App in App Store Connect (10 min)**
- Go to: https://appstoreconnect.apple.com
- My Apps → + → New App
- Bundle ID: `com.rosinante.buildr-test-ios`
- Name: "Buildr Test iOS"

**4. Build and Upload (30 min)**
```bash
# In Xcode:
# 1. Select "Any iOS Device"
# 2. Product → Archive (⌘⌥⇧B)
# 3. Wait for archive to complete
# 4. Click "Distribute App"
# 5. Choose "App Store Connect"
# 6. Upload
```

**5. Add Tester (5 min)**
- App Store Connect → TestFlight
- Internal Testing → Add Tester
- Enter email address
- Tester receives invite

**6. Install and Test (10 min)**
- Install TestFlight app from App Store
- Open invite email
- Install "Buildr Test"
- Verify app works

**✅ Success!** Your app is on TestFlight

---

## Setup GitHub Actions CI/CD (Optional) - 1 Hour

**See:** `GITHUB_SECRETS_SETUP.md` for complete guide

**Quick overview:**
1. Export certificate from Xcode → convert to base64
2. Download provisioning profile → convert to base64
3. Create App Store Connect API key → format as JSON
4. Add 10 secrets to GitHub repository
5. Push to `develop` branch → automatic TestFlight upload

---

## Documentation Files

| File | Purpose | When to Read |
|------|---------|--------------|
| **README.md** | Project overview | Start here |
| **BUILD_INSTRUCTIONS.md** | Manual deployment | Before first deploy |
| **GITHUB_SECRETS_SETUP.md** | CI/CD setup | Setting up automation |
| **TEST_REPORT.md** | Testing status | Check what works |
| **DELIVERY_SUMMARY.md** | Complete summary | Full project details |
| **QUICK_START.md** | This file | Quick reference |

---

## Troubleshooting

**"No signing certificate found"**
```bash
# In Xcode: Settings → Accounts → Manage Certificates
# Create new: + → Apple Distribution
```

**"Build failed"**
```bash
# Clean build folder
# Product → Clean Build Folder (⌘⌥⇧K)
# Try building again
```

**"Can't upload to TestFlight"**
- Verify app exists in App Store Connect
- Check bundle ID matches exactly: `com.rosinante.buildr-test-ios`
- Ensure you have App Manager or Admin role

---

## Project Info

**Bundle ID:** `com.rosinante.buildr-test-ios`  
**Display Name:** Buildr Test  
**Version:** 1.0  
**Min iOS:** 15.0  
**Platforms:** iPhone, iPad  

**Local Path:** `/Users/rosinante/Projects/buildr-test-ios`  
**GitHub:** `rosiinante-alt/buildr-test-ios`

---

## Commands Reference

```bash
# Open project
open buildr-test-ios.xcodeproj

# Build from command line
xcodebuild -project buildr-test-ios.xcodeproj \
  -scheme buildr-test-ios \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  build

# Run tests (when added)
xcodebuild test -scheme buildr-test-ios \
  -destination 'platform=iOS Simulator,name=iPhone 15'

# Archive for distribution
xcodebuild archive \
  -project buildr-test-ios.xcodeproj \
  -scheme buildr-test-ios \
  -archivePath ./build/buildr-test-ios.xcarchive

# Deploy with Fastlane
fastlane ios beta      # TestFlight
fastlane ios release   # App Store
```

---

## Getting Help

1. **Check docs** in this repository first
2. **Buildr System docs** in `/Users/rosinante/Projects/Buildr-System/`
3. **Apple Developer Support:** https://developer.apple.com/support/
4. **Fastlane Docs:** https://docs.fastlane.tools/

---

**Ready to start? Open in Xcode and run in simulator!** 🚀
