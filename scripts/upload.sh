echo "Starting Script"

while getopts a:b:s:S:c:i:e:C:n:P:p:m:D:v:k:y flag
do
    case "${flag}" in
        a) appCenterAppID=${OPTARG};;
        b) buildNumber=${OPTARG};;
        s) scheme=${OPTARG};;
        S) signingIdentity="${OPTARG}";;
        c) config=${OPTARG};;
        C) configPath="${OPTARG}";;
        i) apiIssuer="${OPTARG}";;
        e) exportPath="${OPTARG}";;
        k) apiKey=${OPTARG};;
        n) productName="${OPTARG}";;
        p) path="${OPTARG}";;
        P) profileList+=("${OPTARG}");;
        m) method=${OPTARG};;
        d) destination=${OPTARG};;
        D) dsapHost=${OPTARG};;
        v) versionInfo=${OPTARG};;
        y) uploadSymbols=true;;
#        *) exit 12
    esac
done

#apiKey=$1
#apiIssuer=$2
#echo "apiKey: $apiKey"
#echo "apiIssuer: $apiIssuer"

echo "buildNumber: $buildNumber"
echo "versionInfo: $versionInfo"
echo "Uploading version $versionInfo build $buildNumber"

xcrun altool --upload-app -f "${HOME}/ipa/MemoryMatrix.ipa" --type iOS --show-progress --apiKey $apiKey --apiIssuer $apiIssuer

#newVersion=$versionInfo
#newBuildNumber=$buildNumber
#
#infoPlist="~/bld/MemoryMatrixApp.xcarchive/Products/Applications/MemoryMatrix.app/Info.plist"
#echo "CURRENT"
#echo "========================================"
#version=$(eval "/usr/libexec/PlistBuddy -c 'print CFBundleShortVersionString' $infoPlist")
#buildNumber=$(eval "/usr/libexec/PlistBuddy -c 'print CFBundleVersion' $infoPlist")
#echo "Version: $version"
#echo "Build: $buildNumber"
#productVersion="$version-$buildNumber"
#echo "Product version is ${productVersion}"
#
#eval /usr/libexec/PlistBuddy -c "'Set :CFBundleShortVersionString $newVersion'" $infoPlist
#eval /usr/libexec/PlistBuddy -c "'Set :CFBundleVersion $newBuildNumber'" $infoPlist
#
#echo "UPDATED"
#echo "========================================"
#version=$(eval "/usr/libexec/PlistBuddy -c 'print CFBundleShortVersionString' $infoPlist")
#buildNumber=$(eval "/usr/libexec/PlistBuddy -c 'print CFBundleVersion' $infoPlist")
#echo "Version: $version"
#echo "Build: $buildNumber"
#productVersion="$version-$buildNumber"
#echo "Product version is ${productVersion}"
#
#echo "PACKAGING FOR UPLOAD"
#echo "========================================"
#./scripts/package.sh

echo "Script Completed"
