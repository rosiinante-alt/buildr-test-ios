#!/bin/bash

# Create a basic iOS app using xcodebuild
xcrun xcodebuild -create-xcodeproj \
  -projectname "buildr-test-ios" \
  -target "buildr-test-ios" \
  -sdk iphoneos

