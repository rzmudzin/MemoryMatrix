security find-identity -v -p codesigning
xcodebuild -project MemoryMatrix.xcodeproj clean archive -scheme "MemoryMatrix" -configuration Release -archivePath ~/bld/MemoryMatrixApp.xcarchive CODE_SIGN_IDENTITY="$1" CODE_SIGN_STYLE=Manual PROVISIONING_PROFILE="$2"
