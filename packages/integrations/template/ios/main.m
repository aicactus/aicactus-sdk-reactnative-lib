#import <React/RCTBridgeModule.h>
#import <RNAicactus/RNAicactus.h>
#if defined(__has_include) && __has_include({{{factory_header_alt}}})
#import {{{factory_header_alt}}}
#else
#import {{{factory_header}}}
#endif

@interface {{{integration_class_name}}}: NSObject<RCTBridgeModule>
@end

@implementation {{{integration_class_name}}}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(setup) {
    [RNAicactus addIntegration:{{{factory_class_name}}}.instance];
}

@end
