package io.aicactus.sdk.reactnative.integration.adjust

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import io.aicactus.sdk.reactnative.core.RNAicactus
import io.aicactus.sdk.AicactusSDK
import android.util.Log
import io.aicactus.sdk.android.integrations.adjust.AdjustIntegration

class RNAicactusIntegration_AdjustModule(context: ReactApplicationContext): ReactContextBaseJavaModule(context) {
    override fun getName() = "RNAicactusIntegration_Adjust"

    @ReactMethod
    fun setup() {
        RNAicactus.addIntegration(AdjustIntegration.FACTORY)
        RNAicactus.addOnReadyCallback("Adjust", AicactusSDK.Callback { instance ->
            Log.v("RNAicactusIntegration_Adjust", "Adjust integration ready.")
            if (instance is com.adjust.sdk.AdjustInstance) {
                instance.onResume()
            }
        })
    }
}
