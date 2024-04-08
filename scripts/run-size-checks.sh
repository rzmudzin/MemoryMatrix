#!/bin/bash

while getopts o:p:y:- flag
do
    case "${flag}" in
        o) outputPath="${OPTARG}";;
        p) searchPath="${OPTARG}";;
        y) pythonScriptPath="${OPTARG}";;
        -) break;;
    esac
done


#Override Defaults
if [ -z "$searchPath" ] ; then
    searchPath=~/runners/ios/_work/ios/build/INT/Bonvoy.xcarchive
fi
if [ -z "$outputPath" ] ; then
    outputPath=~/size-violations.csv
fi
if [ -z "$pythonScriptPath" ] ; then
    pythonScriptPath=~/memory_matrix_ci_cd/MemoryMatrix/scripts/check-asset-size.py
fi

#Define max file sizes
pngMax=400000
jpgMax=400000
pdfMax=200000
jsonMax=350000
mp4Max=1500000
carMax=50000000


#Scan assets within iOS catalogs
find "${searchPath}" -name "*.car" -print0 | xargs -0 -I {} echo "{}" | grep -v frame | xargs -I {} python3 "${pythonScriptPath}" --restriction png:${pngMax}:csv --cpath "{}" > "${outputPath}"

find "${searchPath}" -name "*.car" -print0 | xargs -0 -I {} echo "{}" | grep -v frame | xargs -I {} python3 "${pythonScriptPath}" --restriction jpg:${jpgMax}:csv --cpath "{}" >> "${outputPath}"

find "${searchPath}" -name "*.car" -print0 | xargs -0 -I {} echo "{}" | grep -v frame | xargs -I {} python3 "${pythonScriptPath}" --restriction pdf:${pdfMax}:csv --cpath "{}" >> "${outputPath}"

find "${searchPath}" -name "*.car" -print0 | xargs -0 -I {} echo "{}" | grep -v frame | xargs -I {} python3 "${pythonScriptPath}" --restriction pdf:${pdfMax}:csv --cpath "{}" >> "${outputPath}"

find "${searchPath}" -name "*.car" -print0 | xargs -0 -I {} echo "{}" | grep -v frame | xargs -I {} python3 "${pythonScriptPath}" --restriction json:${jsonMax}:csv --cpath "{}" >> "${outputPath}"

find "${searchPath}" -name "*.car" -print0 | xargs -0 -I {} echo "{}" | grep -v frame | xargs -I {} python3 "${pythonScriptPath}" --restriction mp4:${mp4Max}:csv --cpath "{}" >> "${outputPath}"


#Scan folders (excluding iOS framework folders)
python3 "${pythonScriptPath}" --exclude-path-containing-folder Frameworks --exclude-starting-with Frameworks --restriction png:${pngMax}:csv --cpath "${searchPath}" >> "${outputPath}"

python3 "${pythonScriptPath}" --exclude-path-containing-folder Frameworks --exclude-starting-with Frameworks --restriction jpg:${jpgMax}:csv --cpath "${searchPath}" >> "${outputPath}"

python3 "${pythonScriptPath}" --exclude-path-containing-folder Frameworks --exclude-starting-with Frameworks --restriction pdf:${pdfMax}:csv --cpath "${searchPath}" >> "${outputPath}"

python3 "${pythonScriptPath}" --exclude-path-containing-folder Frameworks --exclude-starting-with Frameworks --restriction json:${jsonMax}:csv --cpath "${searchPath}" >> "${outputPath}"

python3 "${pythonScriptPath}" --exclude-path-containing-folder Frameworks --exclude-starting-with Frameworks --restriction mp4:${mp4Max}:csv --cpath "${searchPath}" >> "${outputPath}"


#Check iOS catalog file sizes
find "${searchPath}" -name "*.car" -print0 | xargs -0 -I {} echo "{}" | grep -v frame | xargs -I {} python3 "${pythonScriptPath}" --restriction car:${carMax}:csv --cpath "{}"

