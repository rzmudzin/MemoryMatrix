xcodebuild -exportArchive -archivePath ~/bld/MemoryMatrixApp.xcarchive -exportPath ~/ipa -exportOptionsPlist ~/export.plist

# find "/Users/rzmudzinski/bld/MemoryMatrixApp.xcarchive" -name "*.car" -print0 | xargs -0 -I {} python3 ./scripts/check-asset-size.py --cpath {} ${APP_SIZE_RESTRICTIONS}


