security find-identity -v -p codesigning
xcodebuild -project MemoryMatrix.xcodeproj clean archive -scheme "$3" -configuration "$4" -archivePath "$5" CODE_SIGN_IDENTITY="$1" CODE_SIGN_STYLE=Manual PROVISIONING_PROFILE="$2"
