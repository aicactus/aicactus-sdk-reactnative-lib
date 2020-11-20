#!/bin/bash

set -ex

cfg=""

pushd project/ios
    if [[ $COCOAPODS == "yes" ]]; then
        cp -r ../../patches/Podfile .
        yarn react-native link
        pod install --repo-update
        cfg="cocoapods"
    else
        echo "import {AicactusSDK} from '@tvpsoft/aicactus-react-native'" > ../integrations.gen.ts
        echo "export default [] as AicactusSDK.Integration[]" >> ../integrations.gen.ts
        rm -rf TestApp.xcodeproj
        cp -r ../../patches/TestApp.xcodeproj .
        yarn remove $(cd ../../../integrations/build && echo @tvpsoft/*)
        yarn react-native link
        # yarn add @tvpsoft/aicactus@github:aicactus/aicactus-sdk-ios-lib#1.0.3
        cfg="vanilla"
    fi
popd

yarn detox build --configuration ios-$cfg
yarn detox test --configuration ios-$cfg --loglevel trace
