#export FASTLANE_DISABLE_COLORS=1
#eval $(fastlane spaceauth -u rzmudzin@gmail.com --copy_to_clipboard 2>/dev/null | grep "export FASTLANE_SESSION")

#wget http://phoenixnova.net:8888/Home/CreateFile --output-document=session.txt
#export FASTLANE_SESSION=$(cat session.txt)
#fastlane spaceauth -u rzmudzin@gmail.com --check_session

#export FASTLANE_SESSION="Test"
export FASTLANE_SESSION='---\n- !ruby/object:HTTP::Cookie\n  name: myacinfo\n  value: DAWTKNV323952cf8084a204fb20ab2508441a07d02d3fda30c8eba8dfe4818608e992262cecb647609dd1a8bbf878a67f864ca58cf76545c04e823b10368fee915d90b01d646a3457ca3b1d9db577ca3bb85e53f4109c1ad197dc740463421943b4bd448a0cb636ecb50a8743e9c7c0cb311c06271726856746deb3c5e2bf7ad9b6768dbbe2dc1f7e8f7571ea97aa12a36517eb06a1972c6a664ff6e40db7b0885015bf8c735e037fbef738f8c83f596b551728fddddf14306e45fbf39b2058b5c742d4d4c46add4b5cb7b02a5271d12b8da71633d0fba69a63a45a8713198341235bfc92be6f769c19f4fc36246a894b51c438c935218187a509472f8b6155ed7bc1dbb7f7c639594a2359f5282d5cd58cc6a618eb14d5cc1d6c5ece70277b27d3c2a9955e54a18eb2529afb4d29c882b6a4038dcdafd0a29c096efa9d320cc850880365519a8d4dd100a138459d96bedacb6330343666d3c6162567aeef214c4f690d60457516f68b2e74fb552b8b5483246e85658466d23a573c2fa1403b0fb9a63fb8f7d1a4d0ef4de20bb050e4b12b271387240f66911b856765bb5a812cd4e6cf13392bef7480992a8c517371c08e4ec75b9ab571e1d73e4a8d9ea4e62b52c21c9c92371a6cbe6b8992fc441559efc185ea5eda52c4c8363a966f77512a72f6781bfd08f93afc14a13ff16723a7b35f81fc8c63c3d69d5d044dccee43759c64c667eae573fb9098d3086b7736b83d341df2145921035fd5f071fc7a4de561f957c0c49e6236ecfcff1918ab5e654b05749ea0754e0454e69a9b8be00c642ae3f4f65ddb7e5c49db4b34a5b723ced66daaa76ba71601769b0064a962ab0dae0090257e8fc5546030a5bf469c35154452318a969585a47V3\n  domain: apple.com\n  for_domain: true\n  path: "/"\n  secure: true\n  httponly: true\n  expires:\n  max_age:\n  created_at: 2024-02-20 14:12:36.580054000 -07:00\n  accessed_at: 2024-02-20 14:12:36.590328000 -07:00\n- !ruby/object:HTTP::Cookie\n  name: DES5e273eb1532ad7cd2143ea1e15cd4bc25\n  value: HSARMTKNSRVXWFlaaTQy5lnlgajVAtrC3UioeJOFzKVigbAqwL3kETE2tLVT3gKQaIwEcurN8CbBwWtamaTesNBbNg1AbfyxwEyrQ/ZksnN1UeVinYDmV49Kp9/87L4dFUWOGwglBpoaiKa0w1cL+j1iYfc0r7uAvT7suq57Kk2vYiIy8LKwW6pvqmKY3fs40F6yJ1Toj8xMK9PZifGDbAlImLSpWfPCxt73bF3Z30sZ0ag=SRVX\n  domain: idmsa.apple.com\n  for_domain: true\n  path: "/"\n  secure: true\n  httponly: true\n  expires:\n  max_age: 2592000\n  created_at: &1 2024-02-20 14:12:36.579894000 -07:00\n  accessed_at: *1\n- !ruby/object:HTTP::Cookie\n  name: dqsid\n  value: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3MDg0NjM1OTMsImp0aSI6Ii1MaUhIV2tWTnljVk0zbWVIX0ZfRUEifQ.lq-488R9vKiNnjpY92C3wdy6amBzXOVC0PZlr390Eqk\n  domain: appstoreconnect.apple.com\n  for_domain: false\n  path: "/"\n  secure: true\n  httponly: true\n  expires:\n  max_age: 1800\n  created_at: &2 2024-02-20 14:12:37.594147000 -07:00\n  accessed_at: *2\n'

export WORKFLOW_ID="primary"
export PACKAGE_URL="https://phoenixroberts.net/nuget_files/nuget.sp.tar"
#export PACKAGE_URL="https://phoenixroberts.net/nuget_files/nuget.sp.legacy.tar"
export CFBUNDLEVERSION="3888"
export VERSION="5.0.8"
export CI_PIPELINE_ID="460473012"
export CI_COMMIT_BRANCH="azure"
export CI_COMMIT_SHA="36300c026db3b71e106862a72d4058efb25bff70"
export CI_COMMIT_MESSAGE="Source Code Updated"
export ARTIFACT_FILE_NAME="MemoryMatrix.tar.gz"

JSON=$(jq -c -n \
--arg CI_PIPELINE_ID "$CI_PIPELINE_ID" \
--arg PACKAGE_URL "$PACKAGE_URL" \
--arg WORKFLOW_ID "$WORKFLOW_ID" \
--arg CFBUNDLEVERSION "$CFBUNDLEVERSION" \
--arg VERSION "$VERSION" \
--arg CI_COMMIT_BRANCH "$CI_COMMIT_BRANCH" \
--arg CI_COMMIT_SHA "$CI_COMMIT_SHA" \
--arg CI_COMMIT_MESSAGE "$CI_COMMIT_MESSAGE" \
--arg ARTIFACT_FILE_NAME "$ARTIFACT_FILE_NAME" \
--arg FASTLANE_SESSION "$FASTLANE_SESSION" \
'{"variables":{ "PACKAGE_URL": { "isSecret": false, "value": $PACKAGE_URL }, "CI_PIPELINE_ID": { "isSecret": false, "value": $CI_PIPELINE_ID }, "WORKFLOW_ID": { "isSecret": false, "value": $WORKFLOW_ID }, "CFBUNDLEVERSION": { "isSecret": false, "value": $CFBUNDLEVERSION }, "VERSION": { "isSecret": false, "value": $VERSION }, "CI_COMMIT_BRANCH": { "isSecret": false, "value": $CI_COMMIT_BRANCH }, "CI_COMMIT_SHA": { "isSecret": false, "value": $CI_COMMIT_SHA }, "CI_COMMIT_MESSAGE": { "isSecret": false, "value": $CI_COMMIT_MESSAGE }, "ARTIFACT_FILE_NAME": { "isSecret": false, "value": $ARTIFACT_FILE_NAME }, "FASTLANE_SESSION": { "isSecret": false, "value": $FASTLANE_SESSION } }}')

echo "Request Json"
echo
echo "$JSON"
echo
echo
echo "Executing Request"
#Primary Clone 2
#RESPONSE=$(echo $JSON | curl -L -X POST 'https://dev.azure.com/phxrobertsvstudio/test/_apis/pipelines/19/runs?api-version=6.0-preview.1' -H 'Authorization: Basic OnMzeXBwYjJjNjVwaGhzaWZmcXdzNXR1emUyeTd1dWJ4eWJvNXJkdWZnZXlja2Jta2R4b3E=' -H 'Content-Type: application/json' -d @- )
#Primary

#bHppNXllN2pib2VnbHR1ZGxndGp2dDU3NnZidG5lN3N0amt5ZzVremxmcXlzbHZwZnAyYQ==
#RESPONSE=$(echo $JSON | curl -L -X POST 'https://dev.azure.com/phxrobertsvstudio/test/_apis/pipelines/32/runs?api-version=6.0-preview.1' -H 'Authorization: Basic OnhuY3FydzVjN2hpbnpjNXdyd294cGRobzNzbDNwempsZnduanlxc243Z3k1ZW5xa21nNnE=' -H 'Content-Type: application/json' -d @- )

RESPONSE=$(echo $JSON | curl -L -X POST 'https://dev.azure.com/phxrobertsvstudio/test/_apis/pipelines/12/runs?api-version=6.0-preview.1' -H 'Authorization: Basic OnhuY3FydzVjN2hpbnpjNXdyd294cGRobzNzbDNwempsZnduanlxc243Z3k1ZW5xa21nNnE=' -H 'Content-Type: application/json' -d @- )

#RESPONSE=$(echo $JSON | curl -L -X POST 'https://dev.azure.com/phxrobertsvstudio/test/_apis/pipelines/32/runs?api-version=6.0-preview.1' -H 'Authorization: Basic OnFjbnlzNmMyd2ZiYmppM3R2anJtMnBid2w0cDRjcGR0Mnp3MzJkZG1ubnNjNjZoNnVrdGE=' -H 'Content-Type: application/json' -d @- )

#Ready Plan
#RESPONSE=$(echo $JSON | curl -L -X POST 'https://dev.azure.com/phxrobertsvstudio/test/_apis/pipelines/27/runs?api-version=6.0-preview.1' -H 'Authorization: Basic OnFjbnlzNmMyd2ZiYmppM3R2anJtMnBid2w0cDRjcGR0Mnp3MzJkZG1ubnNjNjZoNnVrdGE=' -H 'Content-Type: application/json' -d @- )
echo
echo
echo "Request Response"
echo
echo "$RESPONSE"
