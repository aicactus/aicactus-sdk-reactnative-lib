package io.aicactus.sdk.reactnative.core

import android.view.View
import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ReactShadowNode
import com.facebook.react.uimanager.ViewManager

class RNAicactusPackage : ReactPackage {
    override fun createViewManagers(context: ReactApplicationContext): List<ViewManager<View, ReactShadowNode<*>>> {
        return emptyList()
    }

    override fun createNativeModules(context: ReactApplicationContext): List<NativeModule> {
        return listOf(RNAicactusModule(context))
    }
}
