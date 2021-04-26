//
//  BZResolver.h
//  BZPromiseKit
//
//  Created by bzdqsmmz on 2021/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class BZBox;
@class BZResult;
@interface BZResolver : NSObject

- (instancetype _Nonnull)initWithBox:(BZBox * _Nonnull)box;

@property (nonatomic, readonly) void (^fulfill)(id _Nullable value);

@property (nonatomic, readonly) void (^reject)(NSError *_Nonnull error);

@property (nonatomic, readonly) void (^resolve)(BZResult *_Nonnull result);
@end

NS_ASSUME_NONNULL_END


