echo "Starting Script"

while getopts a:b:s:S:c:i:e:C:n:P:m:D:y flag
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
        P) profileList+=("${OPTARG}");;
        m) method=${OPTARG};;
        d) destination=${OPTARG};;
        D) dsapHost=${OPTARG};;
        y) uploadSymbols=true;;
#        *) exit 12
    esac
done

#apiKey=$1
#apiIssuer=$2
#echo "apiKey: $apiKey"
#echo "apiIssuer: $apiIssuer"

echo "buildNumber: $buildNumber"
echo "Script Completed"
