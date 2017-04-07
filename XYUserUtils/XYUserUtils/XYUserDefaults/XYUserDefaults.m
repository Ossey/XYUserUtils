//
//  XYUserDefaults.m
//  XYUserDefaults
//
//  Created by Ossey on 17/4/7.
//  Copyright © 2017年 Ossey. All rights reserved.
//

#import "XYUserDefaults.h"

#import "KeychainItemWrapper.h"

static NSString *const keyChainIdentifierKey = @"keyChainIdentifier";
static NSString *const keyChainEncodeKey = @"keyChainEncoder";

@interface XYUserDefaults ()

@property (nonatomic, strong) KeychainItemWrapper *wrapper;
@property (nonatomic, strong) dispatch_queue_t dispatchQueue;
@end

@implementation XYUserDefaults

@dynamic userDefaults;
static XYUserDefaults *_instance;

+ (XYUserDefaults *)userDefaults {

    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:keyChainIdentifierKey accessGroup:nil];
        _dispatchQueue = dispatch_queue_create("com.ossey.XYUserDefaults", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (BOOL)setInteger:(NSInteger)value forKey:(NSString *)defaultName error:(NSError *__autoreleasing  _Nullable * _Nullable)error {
    return [self setObject:@(value) forKey:defaultName error:error];
}
- (BOOL)setFloat:(float)value forKey:(NSString *)defaultName error:(NSError *__autoreleasing  _Nullable * _Nullable)error {
    return [self setObject:@(value) forKey:defaultName error:error];
}
- (BOOL)setDouble:(double)value forKey:(NSString *)defaultName error:(NSError *__autoreleasing  _Nullable * _Nullable)error {
    return [self setObject:@(value) forKey:defaultName error:error];
}
- (BOOL)setBool:(BOOL)value forKey:(NSString *)defaultName error:(NSError *__autoreleasing  _Nullable * _Nullable)error {
    return [self setObject:@(value) forKey:defaultName error:error];
}

- (NSInteger)integerForKey:(NSString *)defaultName {
    return [[self objectForKey:defaultName] integerValue];
}
- (float)floatForKey:(NSString *)defaultName {
    return [[self objectForKey:defaultName] floatValue];
}
- (double)doubleForKey:(NSString *)defaultName {
    return [[self objectForKey:defaultName] doubleValue];
}
- (BOOL)boolForKey:(NSString *)defaultName {
    return [[self objectForKey:defaultName] boolValue];
}

- (BOOL)removeObjectForKey:(NSString *)defaultName {
    return [self setObject:nil forKey:defaultName error:nil];
}

- (BOOL)setObject:(nullable id<NSCopying, NSObject>)value forKey:(NSString *)defaultName error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    
    __block BOOL isMatchClass = NO;
    
    [@[[NSString class],
       [NSData class],
       [NSDate class],
       [NSValue class]] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           Class class = obj;
           if ([value isKindOfClass:class]) {
               isMatchClass = YES;
               *stop = YES;
           }
           
       }];
    
    if (!isMatchClass && value) {
        //@throw [NSException exceptionWithName:@"XYUserDefaults Error" reason:[NSString stringWithFormat:@"value的数据类型不符，value [%@]", value] userInfo:nil];
        NSError *e = [XYUserDefaults errorWithDomain:@"XYUserDefaults Error" errorMessage:[NSString stringWithFormat:@"value的数据类型不符，value [%@]", value] code:1001];
        if (error) {
            *error = e;
        }
        return NO;
        
    }
    
    if (!defaultName || !self.wrapper) {
        NSError *e = [XYUserDefaults errorWithDomain:@"XYUserDefaults Error" errorMessage:@"key不能为nil，或者KeychainItemWrapper不存在" code:1001];
        if (error) {
            *error = e;
        }
        return NO;
    }
    
    id data = [self.wrapper objectForKey:(__bridge id)kSecValueData];
    NSMutableDictionary *dict = nil;
    if (data && [data isKindOfClass:[NSMutableData class]]) {
        dict = [self decodeDictWithData:data];
    }
    
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    dict[defaultName] = value;
    data = [self encodeDict:dict];
    
    if (data && [data isKindOfClass:[NSMutableData class]]) {
        [self.wrapper setObject:keyChainIdentifierKey forKey:(__bridge id)(kSecAttrAccount)];
        [self.wrapper setObject:data forKey:(__bridge id)kSecValueData];
    }
    return YES;
    
}

- (id)objectForKey:(NSString *)defaultName {
    if (!defaultName || !self.wrapper) {
        return nil;
    }
    
    id data = [self.wrapper objectForKey:(__bridge id)kSecValueData];
    NSMutableDictionary *dict = nil;
    if (data && [data isKindOfClass:[NSMutableData class]]) {
        dict = [self decodeDictWithData:data];
    }
    
    return dict[defaultName];
}

- (BOOL)reset {

    if (!self.wrapper) {
        return NO;
    }
    
    id data = [self encodeDict:[NSMutableDictionary dictionary]];
    
    if (data && [data isKindOfClass:[NSMutableData class]]) {
        [self.wrapper setObject:keyChainIdentifierKey forKey:(__bridge id)(kSecAttrAccount)];
        [self.wrapper setObject:data forKey:(__bridge id)kSecValueData];
    }
    return YES;
}

- (NSMutableData *)encodeDict:(NSMutableDictionary *)dict {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:keyChainEncodeKey];
    [archiver finishEncoding];
    return data;
}

- (NSMutableDictionary *)decodeDictWithData:(NSMutableData *)data {
    NSMutableDictionary *dict = nil;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    if ([unarchiver containsValueForKey:keyChainEncodeKey]) {
        @try {
            dict = [unarchiver decodeObjectForKey:keyChainEncodeKey];
        }
        @catch (NSException *exception) {
            @throw exception;
            [self reset];
        }
    }
    [unarchiver finishDecoding];
    
    return dict;
}

+ (NSError *)errorWithDomain:(NSString *)domain errorMessage:(NSString *)message code:(NSInteger)code {
    NSError *error = [NSError errorWithDomain:domain code:code userInfo:@{NSLocalizedDescriptionKey: message}];
    NSLog(@"error: [%@] %@", @(error.code), error.localizedDescription);
    return error;
}


#pragma mark - 初始化

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

@end

