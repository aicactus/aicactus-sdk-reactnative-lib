package {{{classpath}}}

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import io.aicactus.sdk.reactnative.core.RNAicactus
import io.aicactus.sdk.AicactusSDK
import android.util.Log
import {{{factoryImport}}}

class {{{nativeModule}}}Module(context: ReactApplicationContext): ReactContextBaseJavaModule(context) {
    override fun getName() = "{{{nativeModule}}}"

    @ReactMethod
    fun setup() {
        RNAicactus.addIntegration({{{factoryClass}}}.FACTORY)

        RNAicactus.addOnReadyCallback("{{{slug}}}", Analytics.Callback { instance ->
            Log.v("{{{nativeModule}}}", "{{{slug}}} integration ready.")
        })
    }
}
