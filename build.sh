#!/bin/bash

export WORKSPACE=`pwd`

cd $WORKSPACE

# Download android-studio tool
wget https://dl.google.com/dl/android/studio/ide-zips/2025.2.1.8/android-studio-2025.2.1.8-linux.tar.gz
tar -xvzf android-studio-2025.2.1.8-linux.tar.gz

# Install Java JDK 17
sudo apt install openjdk-17-jdk

# Install SDK
pushd ${WORKSPACE}/cmdline-tools/bin > /dev/null
./sdkmanager --sdk_root=${WORKSPACE}/android-studio "platform-tools" "platforms;android-29" \
				"build-tools;30.0.3" "cmake;3.10.2.4988404"
# Install NDK
./sdkmanager --sdk_root=${WORKSPACE}/android-studio --install "ndk;26.3.11579264"
popd > /dev/null

# Set Environment Variables
export ANDROID_SDK_HOME=$WORKSPACE/android-studio/
export ANDROID_NDK_HOME=${ANDROID_SDK_HOME}/ndk/26.3.11579264

export PATH=$PATH:$ANDROID_NDK_HOME
export PATH=$PATH:${ANDROID_SDK_HOME}/platform-tools
export PATH=$PATH:${ANDROID_SDK_HOME}/build-tools/30.0.3

export JAVA_HOME=/usr/lib/jvm/java-1.17.0-openjdk-amd64/

# Clone the Repository
git clone --recurse-submodules https://github.com/ARM-software/vktrace-arm.git

# To fix the keytool error "The -keyalg option must be specified."
rm -rf ~/.android/debug.keystore
keytool -genkey -v -keystore ~/.android/debug.keystore -storepass android -alias androiddebugkey -keypass android -dname "CN=Android Debug,O=Android,C=US" -keyalg RSA

# Android Build
pushd ${WORKSPACE}/vktrace-arm > /dev/null
./build_vktrace.sh --target android --build-type release --update-external true
popd > /dev/null

