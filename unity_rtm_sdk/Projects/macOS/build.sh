#!/bin/bash
## ==============================================================================
## build script for RTM plugin for Mac on Unity
## required environmental variables:
##   $RTM_VERSION
## optional variables:
##   $APPLE_TEAM_ID
## Note: replace the team id for signing on agoraRTMCWrapper.xcodeproj/project.pbxproj
##	 by setting up environment variable APPLE_TEAM_ID
## ==============================================================================
PLATFORM="Mac"

function download_library {
    DOWNLOAD_URL=$1
    DOWNLOAD_FILE="MacOS_Native.zip"
    
    if [[ ! -e $DOWNLOAD_FILE ]]; then
        wget $DOWNLOAD_URL -O $DOWNLOAD_FILE
    fi
    #unzip
    unzip -o $DOWNLOAD_FILE
}

function replace_teamID {
    PBXPROJ="agoraRTMCWrapper.xcodeproj/project.pbxproj"
    TMPFILE="/tmp/agoraRTMCWrapper.pbxproj"
    OLD="DEVELOPMENT_TEAM = W23FQX89GP;"
    NEW="DEVELOPMENT_TEAM = $1;"
    while IFS= read -r line; do
      line="${line/$OLD/$NEW}"
      # ...
      printf '%s\n' "$line"
    done < $PBXPROJ > $TMPFILE

    if [ -f $TMPFILE ]; then
	mv $TMPFILE $PBXPROJ
	echo "Replaced team id in $PBXPROJ"
    fi
}


function Clean {
    echo "removing $PLATFORM build intermitten files..."
    rm -rf sdk *.zip Agora_RTM_SDK_for_$PLATFORM  
    rm -rf obj libs bin output
}


if [ "$1" == "clean" ]; then
    Clean
    exit 0
fi

# We will require the setting of RTM_VERSION environmental variable
if [ -z ${RTM_VERSION+x} ]; then
    echo "ERROR, environment variable RTM_VERSION (e.g. 'v1_4_2') must be set!"
    exit 1
    else echo "$PLATFORM RTM_VERSION = $RTM_VERSION"
fi

#use environment variable BUILD_CONFIG and BUILD_TARGET to config build
BUILD_CONFIG=${BUILD_CONFIG:=Release}
BUILD_TARGET=${BUILD_TARGET:=clean build}

export build_config=$BUILD_CONFIG
export output_root="output"
export output_build_tmp_path="output/tmp"

# MAC
export macosx_config="macosx"


echo ******** Settings ********
echo BUILD_CONFIG=$BUILD_CONFIG
echo BUILD_TARGET=$BUILD_TARGET
echo BUILD_TARGET CLEAN =  "${BUILD_TARGET#clean}" 
echo

# contains clean target?
if [ "${BUILD_TARGET#clean}" != "$BUILD_TARGET" ]; then
    rm -rf output && echo "output/ is deleted"
fi

mkdir -p ./${output_root}/${build_config} || exit 1

# download the library file
download_library $1

# replace team id for signing
# if [ -n $APPLE_TEAM_ID ]; then 
#    echo replace_teamID $APPLE_TEAM_ID
#    replace_teamID $APPLE_TEAM_ID
# fi

module_name=agoraRTMCWrapper
SDK_DIR=$PWD/sdk

# MAC 
xcodebuild -project ${module_name}.xcodeproj -target ${module_name} -configuration ${build_config} -sdk ${macosx_config} ${BUILD_TARGET} SYMROOT=${output_build_tmp_path} ${EXTRACFLAGS} || exit 1

rm -rf $SDK_DIR

cp -r output/tmp/Release/ $SDK_DIR

# Unity needs this dylib in Resources folder
(cd sdk/agoraRTMCWrapper.bundle/Contents && mv Frameworks Resources)

echo "------ FINISHED --------"
# echo "Created ./${output_build_tmp_path}/${build_config}/${module_name}.bundle"
echo
echo "Success! => MacOS RTM plugin is created in $SDK_DIR"
exit 0
