# Buildr System - iOS/macOS Fastfile
# Automated CI/CD for iOS and macOS apps

default_platform(:ios)

platform :ios do
  desc "Build and upload to TestFlight"
  lane :beta do
    # Validate environment
    ensure_env_vars(
      env_vars: ["XCODE_PROJECT", "SCHEME", "BUNDLE_ID"]
    )
    
    # Optional: Match certificates (if using fastlane match)
    # match(type: "appstore", readonly: true)
    
    # Increment build number
    increment_build_number(
      xcodeproj: ENV["XCODE_PROJECT"],
      build_number: latest_testflight_build_number + 1
    )
    
    # Build the app
    build_app(
      scheme: ENV["SCHEME"],
      configuration: "Release",
      export_method: "app-store",
      export_options: {
        provisioningProfiles: { 
          ENV["BUNDLE_ID"] => ENV["PROVISIONING_PROFILE"]
        }
      },
      output_directory: "./build",
      output_name: "#{ENV['SCHEME']}.ipa"
    )
    
    # Upload to TestFlight
    upload_to_testflight(
      api_key_path: ENV["APP_STORE_CONNECT_API_KEY_PATH"],
      skip_waiting_for_build_processing: true,
      distribute_external: false,
      groups: [ENV["TESTFLIGHT_GROUP"] || "Internal Testers"],
      changelog: ENV["CHANGELOG"] || "Bug fixes and improvements"
    )
    
    # Notify
    notification(
      subtitle: "TestFlight Upload Complete",
      message: "#{ENV['SCHEME']} v#{get_version_number} (#{get_build_number}) uploaded successfully"
    )
  end

  desc "Build for App Store submission"
  lane :release do
    # Validate environment
    ensure_env_vars(
      env_vars: ["XCODE_PROJECT", "SCHEME", "BUNDLE_ID", "VERSION_NUMBER"]
    )
    
    # Optional: Match certificates
    # match(type: "appstore", readonly: true)
    
    # Increment version number
    increment_version_number(
      version_number: ENV["VERSION_NUMBER"],
      xcodeproj: ENV["XCODE_PROJECT"]
    )
    
    # Increment build number
    increment_build_number(
      xcodeproj: ENV["XCODE_PROJECT"],
      build_number: latest_testflight_build_number + 1
    )
    
    # Build
    build_app(
      scheme: ENV["SCHEME"],
      configuration: "Release",
      export_method: "app-store",
      output_directory: "./build",
      output_name: "#{ENV['SCHEME']}.ipa"
    )
    
    # Upload to App Store Connect (does not auto-submit for review)
    upload_to_app_store(
      api_key_path: ENV["APP_STORE_CONNECT_API_KEY_PATH"],
      skip_metadata: true,
      skip_screenshots: true,
      submit_for_review: false,  # Manual review required
      precheck_include_in_app_purchases: false
    )
    
    # Notify
    notification(
      subtitle: "App Store Upload Complete",
      message: "#{ENV['SCHEME']} v#{get_version_number} ready for manual submission"
    )
  end
  
  desc "Run tests"
  lane :test do
    scan(
      scheme: ENV["SCHEME"],
      device: ENV["TEST_DEVICE"] || "iPhone 15",
      code_coverage: true
    )
  end
  
  desc "Setup code signing with match"
  lane :certificates do
    match(
      type: "appstore",
      app_identifier: ENV["BUNDLE_ID"],
      readonly: false
    )
  end
end

platform :mac do
  desc "Build and upload macOS app to TestFlight"
  lane :beta do
    ensure_env_vars(
      env_vars: ["XCODE_PROJECT", "SCHEME", "BUNDLE_ID"]
    )
    
    increment_build_number(
      xcodeproj: ENV["XCODE_PROJECT"]
    )
    
    build_mac_app(
      scheme: ENV["SCHEME"],
      configuration: "Release",
      export_method: "app-store",
      output_directory: "./build"
    )
    
    # Notarize
    notarize(
      package: "./build/#{ENV['SCHEME']}.pkg",
      api_key_path: ENV["APP_STORE_CONNECT_API_KEY_PATH"]
    )
    
    upload_to_testflight(
      api_key_path: ENV["APP_STORE_CONNECT_API_KEY_PATH"],
      skip_waiting_for_build_processing: true
    )
  end
  
  desc "Build and package macOS app for Mac App Store"
  lane :release do
    ensure_env_vars(
      env_vars: ["XCODE_PROJECT", "SCHEME", "BUNDLE_ID", "VERSION_NUMBER"]
    )
    
    increment_version_number(
      version_number: ENV["VERSION_NUMBER"],
      xcodeproj: ENV["XCODE_PROJECT"]
    )
    
    build_mac_app(
      scheme: ENV["SCHEME"],
      configuration: "Release",
      export_method: "app-store",
      output_directory: "./build"
    )
    
    # Notarize
    notarize(
      package: "./build/#{ENV['SCHEME']}.pkg",
      api_key_path: ENV["APP_STORE_CONNECT_API_KEY_PATH"]
    )
    
    upload_to_app_store(
      api_key_path: ENV["APP_STORE_CONNECT_API_KEY_PATH"],
      skip_metadata: true,
      skip_screenshots: true,
      submit_for_review: false,
      platform: "osx"
    )
  end
end

# Error handling
error do |lane, exception|
  notification(
    subtitle: "Build Failed",
    message: "#{lane} failed: #{exception.message}"
  )
end
