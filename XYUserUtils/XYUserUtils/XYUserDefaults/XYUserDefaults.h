//
//  XYUserDefaults.h
//  XYUserDefaults
//
//  Created by Ossey on 17/4/7.
//  Copyright © 2017年 Ossey. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYUserDefaults : NSObject <NSCopying, NSMutableCopying>

#if FOUNDATION_SWIFT_SDK_EPOCH_AT_LEAST(8)
@property (class, readonly, strong) XYUserDefaults *userDefaults;
#endif

- (BOOL)setObject:(nullable id<NSCopying, NSObject>)value forKey:(NSString *)defaultName error:(NSError * __nullable __autoreleasing * __nullable)error;
- (nullable id)objectForKey:(NSString *)defaultName;

- (BOOL)setInteger:(NSInteger)value forKey:(NSString *)defaultName error:(NSError * __nullable __autoreleasing * __nullable)error;
- (BOOL)setFloat:(float)value forKey:(NSString *)defaultName error:(NSError * __nullable __autoreleasing * __nullable)error;
- (BOOL)setDouble:(double)value forKey:(NSString *)defaultName error:(NSError * __nullable __autoreleasing * __nullable)error;
- (BOOL)setBool:(BOOL)value forKey:(NSString *)defaultName error:(NSError * __nullable __autoreleasing * __nullable)error;
- (NSInteger)integerForKey:(NSString *)defaultName;
- (float)floatForKey:(NSString *)defaultName;
- (double)doubleForKey:(NSString *)defaultName;
- (BOOL)boolForKey:(NSString *)defaultName;

- (BOOL)removeObjectForKey:(NSString *)defaultName;
- (BOOL)reset;


@end

NS_ASSUME_NONNULL_END

