//
//  OpenCCService.m
//  OpenCC
//
//  Created by gelosie on 12/4/15.
//

#define OPENCC_EXPORT 

#import "OpenCCService.h"
#import <string>
#import "SimpleConverter.hpp"

class SimpleConverter;

@interface OpenCCService() {
    @private opencc::SimpleConverter *simpleConverter;
}

@end

@implementation OpenCCService

+ (NSDictionary *)defaultConfigs {
    static dispatch_once_t onceToken;
    static NSDictionary *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = @{
            @(OpenCCServiceConverterTypeS2T): @"s2t.json",
            @(OpenCCServiceConverterTypeT2S): @"t2s.json",
            @(OpenCCServiceConverterTypeS2TW): @"s2tw.json",
            @(OpenCCServiceConverterTypeTW2S): @"tw2s.json",
            @(OpenCCServiceConverterTypeS2HK): @"s2hk.json",
            @(OpenCCServiceConverterTypeHK2S): @"hk2s.json",
            @(OpenCCServiceConverterTypeS2TWP): @"s2twp.json",
            @(OpenCCServiceConverterTypeTW2SP): @"tw2sp.json",
            @(OpenCCServiceConverterTypeT2HK): @"t2hk.json",
            @(OpenCCServiceConverterTypeT2TW): @"t2tw.json"
        };
    });
    return _instance;
}

- (void)loadConfig:(NSString *)json {
    NSString *config = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:json];
    const std::string *c = new std::string([config UTF8String]);
    simpleConverter = new opencc::SimpleConverter(*c);
}

- (instancetype)initWithConverterType:(OpenCCServiceConverterType)converterType {
    if (self = [super init]) {
        NSString *json = [OpenCCService defaultConfigs][@(converterType)] ?: @"s2t.json";
        [self loadConfig:json];
    }
    return self;
}

- (instancetype)initWithCommand:(NSString *)command {
    if (self = [super init]) {
        [self loadConfig:command];
    }
    return self;
}

- (NSString *)convert:(NSString *)str {
    std::string st = simpleConverter->Convert([str UTF8String]);
    return [NSString stringWithCString:st.c_str() encoding:NSUTF8StringEncoding];
}

- (void)dealloc {
    delete simpleConverter;
}

@end
