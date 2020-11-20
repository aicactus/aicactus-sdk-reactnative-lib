//  RNAicactus.h
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif

@interface RNAicactus: NSObject<RCTBridgeModule>

+(void)addIntegration:(id)factory;

@end
