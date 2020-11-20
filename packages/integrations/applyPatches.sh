#!/bin/bash

# Apply Patches Script
#
# This necessary because Aicactus does not control all of the integrations that are being used.
# Some do not adhere to the project layout that this integration generation step depends on, one
# example is AppsFlyer.
#
# Patches that are applied below should have a comment explaining why the patch is necessary.
# The patch should also be very manual and targeted.  Any files needed for the patch should also
# mimic the `build` directory that gets generated.  This patch application script will be run
# after the integration generation phase.
#
# Please discuss with @bsneed either in person or in github before adding patches.
#

### Adjust patch
#
# Q: Why?
#
# A: This is an adjust integration specific feature, and should not be replicated for
# another integration. Because of this, we copy in a version with the appropriate code
# applied to the Android file, IntegrationModule.kt

# cp "./patches/@aicactus/aicactus-react-native-adjust/android/src/main/java/io/aicactus/sdk/reactnative/integration/adjust/IntegrationModule.kt" "./build/@aicactus/aicactus-react-native-adjust/android/src/main/java/io/aicactus/sdk/reactnative/integration/adjust/IntegrationModule.kt"


