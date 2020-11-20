package io.aicactus.sdk.reactnative.core

import io.aicactus.sdk.AicactusSDK
import io.aicactus.sdk.integrations.Integration

object RNAicactus {
    private val integrations = mutableSetOf<Integration.Factory>()
    private val onReadyCallbacks = mutableMapOf<String, AicactusSDK.Callback<Any?>>()

    fun setIDFA(idfa: String) {
        // do nothing; iOS only.
    }
    
    fun addIntegration(integration: Integration.Factory) {
        integrations.add(integration)
    }

    fun buildWithIntegrations(builder: AicactusSDK.Builder): AicactusSDK {
        for(integration in RNAicactus.integrations) {
            builder.use(integration)
        }

        return builder.build()
    }

    fun addOnReadyCallback(key: String, callback: AicactusSDK.Callback<Any?>) {
        onReadyCallbacks[key] = callback
    }

    fun setupCallbacks(analytics: AicactusSDK) {
        for(integration in RNAicactus.onReadyCallbacks.keys) {
            analytics.onIntegrationReady(integration, RNAicactus.onReadyCallbacks[integration])
        }
    }
}

