from __future__ import annotations
import sys
import os
import json
import argparse
import pathlib
import subprocess
import datetime
from zipfile import ZipFile
from pathlib import Path
from typing import Callable


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)
    

def warningAction(file: str, text: str):
    eprint(text)
    subprocess.call(["echo", "::warning file=" + file + " ::" + text])


def errorAction(file: str, text: str):
    eprint(text)
    subprocess.call(["echo", "::error file=" + file + " " + text])
    
def csvAction(file: str, text: str):
    subprocess.call(["echo", file + "," + text])


class Asset:
    name: str
    renditionName: str
    sizeOnDisk: int

    def __init__(self, name: str, rendition_name: str, size_on_disk: int) -> None:
        self.name = name
        self.renditionName = rendition_name
        self.sizeOnDisk = size_on_disk
 
        
class SizeRestriction:
    def __init__(self, file_extension: str, max_size: int, action: str):
        self.fileExtension = file_extension
        self.maxSize = max_size
        self.action = action
         
         
class SizeCheckConfig:
    def __init__(self):
        self.path: str = ''
        self.sizeRestrictions: [SizeRestriction] = []
        self.excludedStartingWith: [str] = []
        self.excludedEndingWith: [str] = []
        self.excludedPathContainingFolder: [str] = []        
        self.exitCodeOnError = 0
        self.warningsAsErrors = False
        self.statusFunc: Callable[[str], None] = lambda strValue: None       
        
    def isExcludedPath(self, filePath: str):
        fileDirectory = os.path.dirname(filePath)
        filePath = filePath.replace(config.path, "")
        for startsWith in self.excludedStartingWith:
            if filePath.startswith(startsWith):
                return True
        for endsWith in self.excludedEndingWith:
            if filePath.endswith(endsWith):
                return True
        for excludedPath in self.excludedPathContainingFolder:
            if excludedPath in Path(fileDirectory).parts:
                return True            
        return False


def isDebug():
    if sys.gettrace():
        return True
    return False

def scanAssetAPK(config: SizeCheckConfig) -> bool:

    hasSizeErrors = False
    
    with ZipFile(config.path, 'r') as zip: 
        assets = zip.infolist()
        for restriction in config.sizeRestrictions:
            largeFiles = [ i for i in assets if i.compress_size >= restriction.maxSize and i.filename.endswith(restriction.fileExtension)]
            eprint(str(len(largeFiles)) + " files of type " +  restriction.fileExtension + " are large files")
            for largeFile in largeFiles:
                fileName = os.path.basename(largeFile.filename)
                msgText = "File " + fileName + " size of " + str(largeFile.compress_size) + " bytes exceeds threshold of " + str(restriction.maxSize) + " in " + config.path
                if restriction.action == "csv":
                    csvAction(fileName, str(largeFile.compress_size) + "," + largeFile.filename)
                else:
                    if restriction.action == "warn" and config.warningsAsErrors == False:
                        warningAction(fileName, msgText)
                    elif config.warningsAsErrors  or restriction.action == "error":
                        errorAction(fileName, msgText)
                        hasSizeErrors = True
    
    return hasSizeErrors


def scanAssetCatalog(config: SizeCheckConfig) -> bool:

    hasSizeErrors = False
        
    catalogPath = os.path.dirname(os.path.realpath(config.path))
    result = subprocess.run(['xcrun', '--sdk', 'iphoneos','assetutil', '--info', config.path], stdout=subprocess.PIPE)
    assetJsonData: str = result.stdout.decode('utf-8')
    decodedData = json.loads(assetJsonData)
    
    assets: [Asset] = []
    for data in decodedData:
        if "SizeOnDisk" in data and "Name" in data:
            sizeOnDisk = int(data["SizeOnDisk"])
            name = data["Name"]
            renditionName = ""
            if "RenditionName" in data:
                renditionName = data["RenditionName"]
            else:
                renditionName = name
            assets.append(Asset(name, renditionName, sizeOnDisk))
    eprint("Checking " + str(len(assets)) + " Assets")
    
    
    for restriction in config.sizeRestrictions:
        largeFiles = [ i for i in assets if i.sizeOnDisk >= restriction.maxSize and i.renditionName.endswith(restriction.fileExtension)]
        eprint(str(len(largeFiles)) + " files of type " +  restriction.fileExtension + " are large files")
        for largeFile in largeFiles:
            msgText = "File " + largeFile.renditionName + " size of " + str(largeFile.sizeOnDisk) + " bytes exceeds threshold of " + str(restriction.maxSize) + " in " + config.path
            if restriction.action == "csv":
                csvAction(largeFile.renditionName, str(largeFile.sizeOnDisk) + "," + os.path.basename(catalogPath) + "/" + os.path.basename(config.path))
            else:
                if restriction.action == "warn" and config.warningsAsErrors == False:
                    warningAction(largeFile.renditionName, msgText)
                elif config.warningsAsErrors  or restriction.action == "error":
                    errorAction(largeFile.renditionName, msgText)
                    hasSizeErrors = True
                                  
    return hasSizeErrors



def scanFolder(sizeGuardConfig: SizeCheckConfig) -> bool:
    hasSizeErrors = False
    
    for restriction in config.sizeRestrictions:
        for path in Path(config.path).rglob("*" + restriction.fileExtension):
            filePath = str(path)
            fileName = os.path.basename(filePath)
            fileDirectory = os.path.dirname(filePath)
            fileSize = os.path.getsize(filePath)
            if config.isExcludedPath(filePath) == False:
                if fileSize >= restriction.maxSize:
                    msgText = "File " + fileName + " size of " + str(fileSize) + " bytes exceeds threshold of " + str(restriction.maxSize) + " in " + fileDirectory
                    if restriction.action == "csv":
                        csvAction(fileName, str(fileSize) + "," + os.path.basename(config.path) + fileDirectory.replace(config.path, ""))
                    else:
                        if restriction.action == "warn" and config.warningsAsErrors == False:
                            warningAction(fileName, msgText)
                        elif config.warningsAsErrors  or restriction.action == "error":
                            errorAction(fileName, msgText)
                            hasSizeErrors = True
                
        
    return hasSizeErrors

def mainFunc(config: SizeCheckConfig):
    if config == None:
        return
        
    hasSizeErrors = False
    
    eprint("\nProcessing: " + config.path)
    
    if os.path.isfile(config.path):
        fileExtension = pathlib.Path(config.path).suffix.replace(".", "")
        if fileExtension == "car" and (len(config.sizeRestrictions) == 1 and config.sizeRestrictions[0].fileExtension == "car") == False:
            hasSizeErrors = scanAssetCatalog(config)
        else:
            if fileExtension == "apk" and (len(config.sizeRestrictions) == 1 and config.sizeRestrictions[0].fileExtension == "apk") == False:
                scanAssetAPK(config)
            else:
                # Check a single file
                fileSize = os.path.getsize(config.path)
                fileName = os.path.basename(config.path)
                fileDirectory = os.path.dirname(config.path)
                for restriction in config.sizeRestrictions:
                    if restriction.fileExtension == fileExtension and fileSize >= restriction.maxSize:
                        msgText = "File " + fileName + " size of " + str(fileSize) + " bytes exceeds threshold of " + str(restriction.maxSize) + " for " + config.path
                        if restriction.action == "csv":
                            csvAction(fileName, str(fileSize) + "," + os.path.basename(fileDirectory) + "/" + fileName)
                        else:
                            if restriction.action == "warn" and config.warningsAsErrors == False:
                                warningAction(fileName, msgText)
                            elif config.warningsAsErrors  or restriction.action == "error":
                                errorAction(fileName, msgText)
                                hasSizeErrors = True
    else:
        hasSizeErrors = scanFolder(config)
        
    eprint("Processing Completed\n")

    if hasSizeErrors and config.exitCodeOnError != 0:
        eprint("Has size errors, exiting with code " + str(config.exitCodeOnError))
        exit(config.exitCodeOnError)  

if __name__ == '__main__':
    config = SizeCheckConfig()
    
    # warningAction("test.txt", "Test Warning")
    # errorAction("test.txt", "Test Error")
    if isDebug() == False:
        parser = argparse.ArgumentParser()
        parser.add_argument("--cpath", help="Path to evaluate")
        parser.add_argument("--err_exit_code", help="Exit code to raise when an error is encountered")
        parser.add_argument("--warnings-as-errors", action="store_true", help="Treat warnings as errors") 
        parser.add_argument('--restriction', action='append', nargs='+')
        parser.add_argument('--exclude-starting-with', action='append', nargs='+')
        parser.add_argument('--exclude-ending-with', action='append', nargs='+')
        parser.add_argument('--exclude-path-containing-folder', action='append', nargs='+')
        args = parser.parse_args()
        
        config.warningsAsErrors = args.warnings_as_errors
        config.path = args.cpath
        if args.err_exit_code != None:
            config.exitCodeOnError = int(args.err_exit_code)
        if args.exclude_starting_with != None:
            for optionArgs in args.exclude_starting_with:
                for arg in optionArgs:
                    config.excludedStartingWith.append(arg)
        if args.exclude_ending_with != None:
            for optionArgs in args.exclude_ending_with:
                for arg in optionArgs:
                    config.excludedEndingWith.append(arg)                
                    
        if args.exclude_path_containing_folder != None:
            for optionArgs in args.exclude_path_containing_folder:
                for arg in optionArgs:
                    config.excludedPathContainingFolder.append(arg)                        
                    
        if args.restriction != None:
            for optionArgs in args.restriction:
                for arg in optionArgs:
                    restrictionValues=arg.split(":")
                    if len(restrictionValues) == 2:
                        config.sizeRestrictions.append(SizeRestriction(restrictionValues[0], int(restrictionValues[1]), "warn"))
                    elif len(restrictionValues) == 3:
                        config.sizeRestrictions.append(SizeRestriction(restrictionValues[0], int(restrictionValues[1]), restrictionValues[2]))
                
    else:
        # config.path = "/Users/rzmud035/Downloads/Payload2/Marriott-TST.app/Theme_Theme.bundle/Assets.car"
        # config.path = "/Users/rzmud035/Downloads/Payload2/Marriott-TST.app/"
        
        # config.path = "/Users/rzmud035/Downloads/AppDome-Marriott-TST-2881.ipa"
        # config.sizeRestrictions.append(SizeRestriction("ipa", 150000000, "warn"))
        # config.sizeRestrictions.append(SizeRestriction("ipa", 175000000, "error"))
        # config.sizeRestrictions.append(SizeRestriction("png", 500, "warn"))
        # config.sizeRestrictions.append(SizeRestriction("pdf", 1000000, "error"))
        # config.excludedStartingWith.append("Frameworks/")
        
        # # config.path = "/Users/rzmud035/runners/ios/_work/ios/build/INT/Bonvoy.xcarchive"
        # config.path = "/Users/rzmud035/runners/ios/_work/ios/build/INT/Bonvoy.xcarchive/Products/Applications/Marriott-INT.app/Assets.car"
        # # config.path = "/Users/rzmud035/runners/ios/_work/ios/build//INT/Marriott-INT.ipa"
        # config.sizeRestrictions.append(SizeRestriction("car", 500, "warn"))
        # config.sizeRestrictions.append(SizeRestriction("ipa", 500, "warn"))
        
        # config.path = "/Users/rzmud035/Downloads/Non-AppDome Release Gold Build Version 463.zip"
        config.path = "/Users/rzmud035/Downloads/ProdZh_Debug.apk"
        config.sizeRestrictions.append(SizeRestriction("webp", 500000, "csv"))
        scanAssetAPK(config)
        
        
        # config.exitCodeOnError = 44
    mainFunc(config)
