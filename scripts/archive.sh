security find-identity -v -p codesigning
xcodebuild -project MemoryMatrix.xcodeproj clean archive -scheme "MemoryMatrix" -configuration Release -archivePath ~/bld/MemoryMatrixApp.xcarchive CODE_SIGN_IDENTITY="$1" CODE_SIGN_STYLE=Manual PROVISIONING_PROFILE="cc7c62a4-7417-4578-b2f0-30b5f8fd50fe"
