#import <React/RCTBridgeModule.h>
#import <RNAicactus/RNAicactus.h>
#if defined(__has_include) && __has_include(<aicactus-appsflyer-ios/SEGAppsFlyerIntegrationFactory.h>)
#import <aicactus-appsflyer-ios/SEGAppsFlyerIntegrationFactory.h>
#else
#import <aicactus-appsflyer-ios/SEGAppsFlyerIntegrationFactory.h>
#endif

@interface RNAicactusIntegration_AppsFlyer: NSObject<RCTBridgeModule>
@end

@implementation RNAicactusIntegration_AppsFlyer

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(setup) {
    [RNAicactus addIntegration:SEGAppsFlyerIntegrationFactory.instance];
}

@end
