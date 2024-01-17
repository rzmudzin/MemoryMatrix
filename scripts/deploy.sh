echo "Archive, package, and upload..."
set -e
while getopts a:b:s:S:c:i:e:C:n:P:p:m:D:v:y flag
do
    case "${flag}" in
        a) appCenterAppID=${OPTARG};;
        b) buildNumber=${OPTARG};;
        s) scheme=${OPTARG};;
        S) signingIdentity="${OPTARG}";;
        c) config=${OPTARG};;
        C) configPath="${OPTARG}";;
        i) archivePath="${OPTARG}";;
        e) exportPath="${OPTARG}";;
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

./scripts/archive.sh

echo "buildNumber: $buildNumber"
echo "versionInfo: $versionInfo"

newVersion=$versionInfo
newBuildNumber=$buildNumber

archivePath="~/bld/MemoryMatrixApp.xcarchive"
archiveInfoPlist="$archivePath/Info.plist"
infoPlist="$archivePath/Products/Applications/MemoryMatrix.app/Info.plist"

echo "CURRENT"
echo "========================================"
version=$(eval "/usr/libexec/PlistBuddy -c 'print CFBundleShortVersionString' $infoPlist")
buildNumber=$(eval "/usr/libexec/PlistBuddy -c 'print CFBundleVersion' $infoPlist")
packageVersion=$(eval "/usr/libexec/PlistBuddy -c 'print ApplicationProperties:CFBundleShortVersionString' $archiveInfoPlist")
packageBuildNumber=$(eval "/usr/libexec/PlistBuddy -c 'print ApplicationProperties:CFBundleVersion' $archiveInfoPlist")
echo "Package Version: $packageVersion"
echo "Package Build: $packageBuildNumber"
echo "Version: $version"
echo "Build: $buildNumber"
productVersion="$version-$buildNumber"
echo "Product version is ${productVersion}"

eval /usr/libexec/PlistBuddy -c "'Set :CFBundleShortVersionString $newVersion'" $infoPlist
eval /usr/libexec/PlistBuddy -c "'Set :CFBundleVersion $newBuildNumber'" $infoPlist
eval /usr/libexec/PlistBuddy -c "'Set ApplicationProperties:CFBundleShortVersionString $newVersion'" $archiveInfoPlist
eval /usr/libexec/PlistBuddy -c "'Set ApplicationProperties:CFBundleVersion $newBuildNumber'" $archiveInfoPlist

echo "UPDATED"
echo "========================================"
version=$(eval "/usr/libexec/PlistBuddy -c 'print CFBundleShortVersionString' $infoPlist")
buildNumber=$(eval "/usr/libexec/PlistBuddy -c 'print CFBundleVersion' $infoPlist")
packageVersion=$(eval "/usr/libexec/PlistBuddy -c 'print ApplicationProperties:CFBundleShortVersionString' $archiveInfoPlist")
packageBuildNumber=$(eval "/usr/libexec/PlistBuddy -c 'print ApplicationProperties:CFBundleVersion' $archiveInfoPlist")
echo "Package Version: $packageVersion"
echo "Package Build: $packageBuildNumber"
echo "Version: $version"
echo "Build: $buildNumber"
productVersion="$version-$buildNumber"
echo "Product version is ${productVersion}"

echo "PACKAGING FOR UPLOAD"
echo "========================================"

./scripts/package.sh
find ~/bld -name "*" > results.txt
find ~/ipa -name "*" >> results.txt
date > timestamp.txt

