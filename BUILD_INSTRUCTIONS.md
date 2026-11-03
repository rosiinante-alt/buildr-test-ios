# Manual Build Instructions

Follow these steps to manually build and deploy the buildr-test-ios app to TestFlight.

## Prerequisites

- ✅ macOS with Xcode 15+ installed
- ✅ Apple Developer Account ($99/year)
- ✅ Xcode configured with your Apple ID
- ✅ App created in App Store Connect

## Step 1: Configure Apple Developer Account

### 1.1 Add Apple ID to Xcode

1. Open Xcode → Settings (⌘,)
2. Go to **Accounts** tab
3. Click **+** → Add Apple ID
4. Sign in with your Apple Developer credentials

### 1.2 Get Your Team ID

```bash
# List your Team IDs
security find-identity -v -p codesigning

# Or check in Xcode:
# Settings → Accounts → [Your Apple ID] → Team Name → (TEAM_ID)
```

Copy your Team ID (format: ABC123XYZ)

### 1.3 Update buildr.yaml

Edit `buildr.yaml` and replace:
```yaml
team_id: REPLACE_WITH_YOUR_TEAM_ID
```

With your actual Team ID:
```yaml
team_id: ABC123XYZ
```

## Step 2: Configure Code Signing

### Option A: Automatic Signing (Recommended for Testing)

1. Open `buildr-test-ios.xcodeproj` in Xcode
2. Select the **buildr-test-ios** project in the navigator
3. Select the **buildr-test-ios** target
4. Go to **Signing & Capabilities** tab
5. Check ✅ **Automatically manage signing**
6. Select your **Team** from dropdown
7. Verify **Bundle Identifier**: `com.rosinante.buildr-test-ios`

### Option B: Manual Signing (For Production)

1. Go to [Apple Developer Portal](https://developer.apple.com/account/resources)
2. Create an **App ID**: `com.rosinante.buildr-test-ios`
3. Create **Provisioning Profile** (App Store Distribution)
4. Download and double-click to install
5. In Xcode:
   - Uncheck "Automatically manage signing"
   - Select your provisioning profile

## Step 3: Create App in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **My Apps** → **+** → **New App**
3. Fill in:
   - **Platform**: iOS
   - **Name**: Buildr Test iOS
   - **Primary Language**: English (U.S.)
   - **Bundle ID**: com.rosinante.buildr-test-ios
   - **SKU**: buildr-test-ios-001
   - **User Access**: Full Access
4. Click **Create**

## Step 4: Build the App

### Option A: Build in Xcode (Easiest)

1. Open `buildr-test-ios.xcodeproj`
2. Select **Any iOS Device** from the device dropdown
3. Go to **Product** → **Archive** (⌘⌥⇧ B)
4. Wait for build to complete (~2-3 minutes)
5. Archives window will open automatically

### Option B: Build from Command Line

```bash
cd /Users/rosinante/Projects/buildr-test-ios

# Clean build folder
rm -rf build/

# Build and archive
xcodebuild -project buildr-test-ios.xcodeproj \
  -scheme buildr-test-ios \
  -configuration Release \
  -archivePath ./build/buildr-test-ios.xcarchive \
  archive
```

## Step 5: Upload to TestFlight

### Option A: Upload via Xcode (Easiest)

1. In the Archives window (or Window → Organizer → Archives)
2. Select the latest archive
3. Click **Distribute App**
4. Choose **App Store Connect**
5. Choose **Upload**
6. Select options:
   - ✅ Include bitcode: NO
   - ✅ Upload symbols: YES
   - ✅ Manage version and build number: YES (Xcode managed)
7. Click **Next**
8. Review signing certificate (should be "Apple Distribution")
9. Click **Upload**
10. Wait for upload to complete (~5-10 minutes)

### Option B: Upload via Fastlane

```bash
# Install fastlane if not already installed
gem install fastlane

# Set environment variables
export XCODE_PROJECT="buildr-test-ios.xcodeproj"
export SCHEME="buildr-test-ios"
export BUNDLE_ID="com.rosinante.buildr-test-ios"
export TESTFLIGHT_GROUP="Internal Testers"

# Build and upload
fastlane ios beta
```

### Option C: Upload via Command Line

```bash
# Export IPA
xcodebuild -exportArchive \
  -archivePath ./build/buildr-test-ios.xcarchive \
  -exportPath ./build \
  -exportOptionsPlist ExportOptions.plist

# Upload with altool
xcrun altool --upload-app \
  --type ios \
  --file ./build/buildr-test-ios.ipa \
  --username "your-apple-id@example.com" \
  --password "@keychain:AC_PASSWORD"
```

## Step 6: Verify Upload

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. My Apps → **Buildr Test iOS** → **TestFlight** tab
3. Wait for processing (~10-15 minutes)
4. Status will change from "Processing" → "Ready to Submit"

## Step 7: Add TestFlight Testers

### Internal Testers (No Review Required)

1. In App Store Connect → TestFlight
2. Click **Internal Testing** group (or create one)
3. Click **+** next to Testers
4. Add email addresses (must be in your App Store Connect team)
5. Select build to test
6. Click **Save**
7. Testers will receive email invite immediately

### External Testers (Requires Review)

1. Click **External Testing** group
2. Add testers (any email address)
3. Submit for Beta App Review (24-48 hours)

## Step 8: Test the App

1. Testers install **TestFlight** app from App Store
2. Open invite email and tap link
3. In TestFlight app, tap **Install**
4. Open **Buildr Test** app
5. Verify:
   - ✅ Green checkmark displays
   - ✅ "Buildr Test" title shows
   - ✅ "iOS deployment successful!" message appears
   - ✅ Build number displays at bottom

## Troubleshooting

### "No signing certificate found"

```bash
# Check available certificates
security find-identity -v -p codesigning

# If none found, create one in Xcode:
# Settings → Accounts → Manage Certificates → + → Apple Distribution
```

### "Failed to verify bitcode"

In Xcode build settings, set:
- **Enable Bitcode**: NO

### "The archive is invalid"

Ensure:
- Bundle ID matches App Store Connect
- All required capabilities are enabled
- Provisioning profile is valid

### "Upload failed"

Try:
1. Clean build folder: Product → Clean Build Folder (⌘⌥⇧ K)
2. Restart Xcode
3. Re-archive
4. Try uploading again

## Next Steps

Once successful:
1. ✅ Document results in TEST_REPORT.md
2. ✅ Set up GitHub Actions (see GITHUB_SECRETS_SETUP.md)
3. ✅ Test automated deployment

## Reference

- Apple Developer: https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases
- Fastlane: https://docs.fastlane.tools/actions/testflight/
- App Store Connect: https://help.apple.com/app-store-connect/
