//  RNAicactus.m
#import "RNAicactus.h"

#import <AicactusSDK/AicactusSDK.h>
#import <React/RCTBridge.h>

static NSMutableSet* RNAicactusIntegrations = nil;
static NSLock* RNAicactusIntegrationsLock = nil;
static NSString* RNAicactusAdvertisingId = nil;
static BOOL RNAnalyaticsUseAdvertisingId = NO;

@implementation RNAicactus

+(void)addIntegration:(id)factory {
    [RNAicactusIntegrationsLock lock];
    [RNAicactusIntegrations addObject:factory];
    [RNAicactusIntegrationsLock unlock];
}

+(void)initialize {
    [super initialize];

    RNAicactusIntegrations = [NSMutableSet new];
    RNAicactusIntegrationsLock = [NSLock new];
}

RCT_EXPORT_MODULE()

@synthesize bridge = _bridge;

static NSString* singletonJsonConfig = nil;

RCT_EXPORT_METHOD(
     setup:(NSDictionary*)options
          :(RCTPromiseResolveBlock)resolver
          :(RCTPromiseRejectBlock)rejecter
) {
    NSString* json = options[@"json"];

    if(singletonJsonConfig != nil) {
        if([json isEqualToString:singletonJsonConfig]) {
            return resolver(nil);
        }
        else {
            #if DEBUG
                return resolver(self);
            #else
                return rejecter(@"E_AICACTUS_RECONFIGURED", @"AICactus SDK Client was allocated multiple times, please check your environment.", nil);
            #endif
        }
    }

    SEGAnalyticsConfiguration* config = [SEGAnalyticsConfiguration configurationWithWriteKey:options[@"writeKey"]];

    config.recordScreenViews = [options[@"recordScreenViews"] boolValue];
    config.trackApplicationLifecycleEvents = [options[@"trackAppLifecycleEvents"] boolValue];
    config.flushAt = [options[@"flushAt"] integerValue];
    config.enableAdvertisingTracking = RNAnalyaticsUseAdvertisingId = [options[@"ios"][@"trackAdvertising"] boolValue];
    config.defaultSettings = options[@"defaultProjectSettings"];

    // set this block regardless.  the data will come in after the fact most likely.
    config.adSupportBlock = ^NSString * _Nonnull{
        return RNAicactusAdvertisingId;
    };

    if ([options valueForKey:@"proxy"]) {
        NSDictionary *proxyOptions = (NSDictionary *)[options valueForKey:@"proxy"];

        config.requestFactory = ^(NSURL *url) {
            NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];

            if ([proxyOptions valueForKey:@"scheme"]) {
                components.scheme = [proxyOptions[@"scheme"] stringValue];
            }

            if ([proxyOptions valueForKey:@"host"]) {
                components.host = [proxyOptions[@"host"] stringValue];
            }

            if ([proxyOptions valueForKey:@"port"]) {
                components.port = [NSNumber numberWithInt:[proxyOptions[@"port"] intValue]];
            }

            if ([proxyOptions valueForKey:@"path"]) {
                components.path = [[proxyOptions[@"path"] stringValue] stringByAppendingString:components.path];
            }

            NSURL *transformedURL = components.URL;
            return [NSMutableURLRequest requestWithURL:transformedURL];
        };
    }

    for(id factory in RNAicactusIntegrations) {
        [config use:factory];
    }

    [SEGAnalytics debug:[options[@"debug"] boolValue]];

    @try {
        [SEGAnalytics setupWithConfiguration:config];
    }
    @catch(NSError* error) {
        return rejecter(@"E_AICACTUS_ERROR", @"Unexpected native Analtyics error", error);
    }

    // On iOS we use method swizzling to intercept lifecycle events
    // However, React-Native calls our library after applicationDidFinishLaunchingWithOptions: is called
    // We fix this by manually calling this method at setup-time
    // TODO(fathyb): We should probably implement a dedicated API on the native part
    if(config.trackApplicationLifecycleEvents) {
        SEL selector = @selector(_applicationDidFinishLaunchingWithOptions:);

        if ([Aicactus.shared respondsToSelector:selector]) {
            [Aicactus.shared performSelector:selector
                                               withObject:_bridge.launchOptions];
        }
    }

    singletonJsonConfig = json;
    return resolver(nil);
}

- (NSDictionary*)withContextAndIntegrations :(NSDictionary*)context :(NSDictionary*)integrations {
    return @{ @"context": context, @"integrations": integrations ?: @{}};
}

RCT_EXPORT_METHOD(setIDFA:(NSString *)idfa) {
    RNAicactusAdvertisingId = idfa;
}


RCT_EXPORT_METHOD(track:(NSString*)name :(NSDictionary*)properties :(NSDictionary*)integrations :(NSDictionary*)context) {
    [Aicactus.shared track:name
                             properties:properties
                                options:[self withContextAndIntegrations :context :integrations]];
}

RCT_EXPORT_METHOD(screen:(NSString*)name :(NSDictionary*)properties :(NSDictionary*)integrations :(NSDictionary*)context) {
    [Aicactus.shared screen:name
                              properties:properties
                                 options:[self withContextAndIntegrations :context :integrations]];
}

RCT_EXPORT_METHOD(identify:(NSString*)userId :(NSDictionary*)traits :(NSDictionary*)integrations :(NSDictionary*)context) {
    [Aicactus.shared identify:userId
                                    traits:traits
                                   options:[self withContextAndIntegrations :context :integrations]];
}

RCT_EXPORT_METHOD(group:(NSString*)groupId :(NSDictionary*)traits :(NSDictionary*)integrations :(NSDictionary*)context) {
    [Aicactus.shared group:groupId
                                 traits:traits
                                options:[self withContextAndIntegrations :context :integrations]];
}

RCT_EXPORT_METHOD(alias:(NSString*)newId :(NSDictionary*)integrations :(NSDictionary*)context) {
    [Aicactus.shared alias:newId
                                options:[self withContextAndIntegrations :context :integrations]];
}

RCT_EXPORT_METHOD(reset) {
    [Aicactus.shared reset];
}

RCT_EXPORT_METHOD(flush) {
    [Aicactus.shared flush];
}

RCT_EXPORT_METHOD(enable) {
    [Aicactus.shared enable];
}

RCT_EXPORT_METHOD(disable) {
    [Aicactus.shared disable];
}

RCT_EXPORT_METHOD(
    getAnonymousId:(RCTPromiseResolveBlock)resolver
                  :(RCTPromiseRejectBlock)rejecter)
{
  NSString *anonymousId = [Aicactus.shared getAnonymousId];
  resolver(anonymousId);
}

@end
