# GitHub Secrets Setup Guide

This guide explains how to configure GitHub Secrets for automated iOS deployment via GitHub Actions.

## Overview

GitHub Actions requires sensitive credentials (certificates, API keys, provisioning profiles) to build and deploy your iOS app. These are stored as encrypted secrets in your GitHub repository.

## Required Secrets

You need to configure **10 secrets** in your GitHub repository:

| Secret Name | Description | How to Get |
|------------|-------------|-----------|
| `BUILD_CERTIFICATE_BASE64` | Code signing certificate (P12) encoded in base64 | See Step 1 below |
| `P12_PASSWORD` | Password for the P12 certificate | Password you set when exporting |
| `PROVISIONING_PROFILE_BASE64` | Provisioning profile encoded in base64 | See Step 2 below |
| `PROVISIONING_PROFILE_NAME` | Name of the provisioning profile | From Apple Developer Portal |
| `APP_STORE_CONNECT_API_KEY_JSON` | App Store Connect API key in JSON format | See Step 3 below |
| `KEYCHAIN_PASSWORD` | Temporary keychain password for CI | Any secure random password |
| `XCODE_PROJECT` | Xcode project file name | `buildr-test-ios.xcodeproj` |
| `SCHEME` | Xcode scheme name | `buildr-test-ios` |
| `BUNDLE_ID` | App bundle identifier | `com.rosinante.buildr-test-ios` |
| `TESTFLIGHT_GROUP` | TestFlight testing group name | `Internal Testers` |

---

## Step 1: Export and Encode Certificate

### 1.1 Export Certificate from Xcode

1. Open **Xcode** → **Settings** (⌘,)
2. Go to **Accounts** tab
3. Select your Apple ID
4. Click **Manage Certificates**
5. Right-click on **Apple Distribution** certificate
6. Click **Export Certificate**
7. Save as `certificate.p12`
8. Set a password (remember this!)

### 1.2 Convert to Base64

```bash
# Navigate to where you saved the certificate
cd ~/Downloads

# Convert to base64 and copy to clipboard
base64 -i certificate.p12 | pbcopy

# The base64 string is now in your clipboard
# Paste this as BUILD_CERTIFICATE_BASE64 secret
```

### 1.3 Store Password

The password you set in step 1.1 becomes your `P12_PASSWORD` secret.

---

## Step 2: Download and Encode Provisioning Profile

### 2.1 Create Provisioning Profile (if needed)

1. Go to [Apple Developer Portal](https://developer.apple.com/account/resources/profiles)
2. Click **+** to create new profile
3. Select **App Store** distribution profile
4. Select your App ID: `com.rosinante.buildr-test-ios`
5. Select your **Distribution Certificate**
6. Name it: `buildr-test-ios Distribution Profile`
7. Click **Generate**
8. Download the `.mobileprovision` file

### 2.2 Convert to Base64

```bash
# Navigate to Downloads
cd ~/Downloads

# Find your provisioning profile
ls -la *.mobileprovision

# Convert to base64 and copy to clipboard
base64 -i buildr_test_ios_Distribution_Profile.mobileprovision | pbcopy

# The base64 string is now in your clipboard
# Paste this as PROVISIONING_PROFILE_BASE64 secret
```

### 2.3 Get Profile Name

The profile name from step 2.1 becomes your `PROVISIONING_PROFILE_NAME` secret:
```
buildr-test-ios Distribution Profile
```

---

## Step 3: Create App Store Connect API Key

### 3.1 Generate API Key

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **Users and Access**
3. Select **Integrations** tab (or **Keys** tab)
4. Click **+** (Generate API Key)
5. Name it: `Buildr CI/CD`
6. Access: **App Manager** or **Admin**
7. Click **Generate**
8. **Download** the `.p8` file (you can only download once!)
9. Note the **Key ID** (e.g., `ABC123XYZ`)
10. Note the **Issuer ID** (e.g., `12345678-1234-1234-1234-123456789012`)

### 3.2 Create API Key JSON

Create a JSON file with this format:

```json
{
  "key_id": "ABC123XYZ",
  "issuer_id": "12345678-1234-1234-1234-123456789012",
  "key": "-----BEGIN PRIVATE KEY-----\nMIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQg...\n-----END PRIVATE KEY-----",
  "duration": 1200,
  "in_house": false
}
```

To get the `key` value:

```bash
# Read the .p8 file and format it
cat AuthKey_ABC123XYZ.p8

# Copy the entire output including:
# -----BEGIN PRIVATE KEY-----
# (all the lines)
# -----END PRIVATE KEY-----

# Replace \n in the JSON with actual newlines in the key field
```

Save this JSON content as your `APP_STORE_CONNECT_API_KEY_JSON` secret.

---

## Step 4: Generate Keychain Password

Create a secure random password for the temporary CI keychain:

```bash
# Generate a random password
openssl rand -base64 32

# Save this output as KEYCHAIN_PASSWORD secret
```

---

## Step 5: Add Secrets to GitHub

### 5.1 Navigate to Repository Secrets

1. Go to your GitHub repository: `https://github.com/rosiinante-alt/buildr-test-ios`
2. Click **Settings** tab
3. Click **Secrets and variables** → **Actions**
4. Click **New repository secret**

### 5.2 Add Each Secret

For each secret, click **New repository secret** and enter:

**1. BUILD_CERTIFICATE_BASE64**
```
Name: BUILD_CERTIFICATE_BASE64
Value: [Paste base64 certificate from Step 1]
```

**2. P12_PASSWORD**
```
Name: P12_PASSWORD
Value: [Your certificate password from Step 1]
```

**3. PROVISIONING_PROFILE_BASE64**
```
Name: PROVISIONING_PROFILE_BASE64
Value: [Paste base64 provisioning profile from Step 2]
```

**4. PROVISIONING_PROFILE_NAME**
```
Name: PROVISIONING_PROFILE_NAME
Value: buildr-test-ios Distribution Profile
```

**5. APP_STORE_CONNECT_API_KEY_JSON**
```
Name: APP_STORE_CONNECT_API_KEY_JSON
Value: [Paste entire JSON from Step 3]
```

**6. KEYCHAIN_PASSWORD**
```
Name: KEYCHAIN_PASSWORD
Value: [Paste random password from Step 4]
```

**7. XCODE_PROJECT**
```
Name: XCODE_PROJECT
Value: buildr-test-ios.xcodeproj
```

**8. SCHEME**
```
Name: SCHEME
Value: buildr-test-ios
```

**9. BUNDLE_ID**
```
Name: BUNDLE_ID
Value: com.rosinante.buildr-test-ios
```

**10. TESTFLIGHT_GROUP**
```
Name: TESTFLIGHT_GROUP
Value: Internal Testers
```

---

## Step 6: Verify Secrets

After adding all secrets, you should see 10 secrets listed:

- ✅ BUILD_CERTIFICATE_BASE64
- ✅ P12_PASSWORD
- ✅ PROVISIONING_PROFILE_BASE64
- ✅ PROVISIONING_PROFILE_NAME
- ✅ APP_STORE_CONNECT_API_KEY_JSON
- ✅ KEYCHAIN_PASSWORD
- ✅ XCODE_PROJECT
- ✅ SCHEME
- ✅ BUNDLE_ID
- ✅ TESTFLIGHT_GROUP

---

## Step 7: Test GitHub Actions

### 7.1 Trigger Workflow

```bash
# Commit and push to develop branch
git checkout -b develop
git add .
git commit -m "Initial commit with CI/CD"
git push origin develop
```

### 7.2 Monitor Build

1. Go to GitHub → **Actions** tab
2. Watch **iOS Build & Deploy** workflow
3. Build takes ~15-25 minutes
4. Check logs if any errors occur

### 7.3 Check TestFlight

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. My Apps → **Buildr Test iOS** → **TestFlight**
3. Wait for build processing (~10-15 minutes after upload)
4. Build should appear under Internal Testing

---

## Troubleshooting

### "Certificate not found"

- Verify `BUILD_CERTIFICATE_BASE64` is correct
- Ensure certificate is valid (not expired)
- Check `P12_PASSWORD` is correct

### "Provisioning profile doesn't match"

- Verify `BUNDLE_ID` matches exactly: `com.rosinante.buildr-test-ios`
- Ensure provisioning profile includes your distribution certificate
- Check `PROVISIONING_PROFILE_NAME` matches exactly

### "API authentication failed"

- Verify `APP_STORE_CONNECT_API_KEY_JSON` format is correct
- Ensure the API key has not been revoked
- Check `key_id` and `issuer_id` are correct

### "Upload to TestFlight failed"

- Ensure app exists in App Store Connect
- Verify bundle ID matches: `com.rosinante.buildr-test-ios`
- Check build number is unique

---

## Security Notes

⚠️ **Important Security Practices:**

1. **Never commit secrets to git** - Always use GitHub Secrets
2. **Rotate API keys periodically** - Update secrets when rotated
3. **Use separate keys per project** - Don't reuse API keys
4. **Backup certificates** - Store P12 files securely
5. **Limit API key access** - Use minimum required permissions

---

## Reference

- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi)
- [Fastlane Codesigning](https://docs.fastlane.tools/codesigning/getting-started/)
- [Buildr System iOS Setup](https://github.com/yourorg/Buildr-System/blob/main/IOS_SETUP_GUIDE.md)

---

## Quick Reference Commands

```bash
# Export certificate to base64
base64 -i certificate.p12 | pbcopy

# Export provisioning profile to base64
base64 -i profile.mobileprovision | pbcopy

# Generate random keychain password
openssl rand -base64 32

# Read .p8 API key file
cat AuthKey_ABC123XYZ.p8

# List available certificates
security find-identity -v -p codesigning
```
