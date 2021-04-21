//
//  BZPromise.h
//  BZPromiseKit
//
//  Created by xiaheqi on 2021/4/21.
//

#import <Foundation/Foundation.h>
#import "BZBox.h"
NS_ASSUME_NONNULL_BEGIN

@class BZResult;
@class BZResolver;
@interface BZPromise : NSObject
+ (instancetype)promiseWithValue:(id _Nullable )value;
+ (instancetype)promiseWithError:(NSError *)error;
+ (instancetype)promiseWithResolver:(void(^)(BZResolver *resolver))body;

@property (nonatomic, readonly, nullable) BZResult *result;

@property (nonatomic, readonly) void (^pipe)(BZBoxValueHandle);
@end

NS_ASSUME_NONNULL_END
