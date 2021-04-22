//
//  BZPromise.h
//  BZPromiseKit
//
//  Created by xiaheqi on 2021/4/21.
//

#import <Foundation/Foundation.h>

@class BZBox;
@class BZResult;
@class BZResolver;

typedef void(^_Nullable BZPromisePipeBlock)(BZResult* _Nullable v);

NS_ASSUME_NONNULL_BEGIN
@interface BZPromise : NSObject
+ (instancetype)promise;
+ (instancetype)promiseWithValue:(id _Nullable )value;
+ (instancetype)promiseWithError:(NSError *)error;
+ (instancetype)promiseWithResolver:(void(^)(BZResolver *resolver))body;

- (instancetype)initWithBox:(BZBox *)box;

@property (nonatomic, readonly, nullable) BZResult *result;

@property (nonatomic, readonly) void (^pipe)(BZPromisePipeBlock);

@property (nonatomic, readonly) void (^seal)(BZResult* _Nullable r);
@end

NS_ASSUME_NONNULL_END
