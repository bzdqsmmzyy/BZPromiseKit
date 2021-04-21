//
//  BZResolver.h
//  BZPromiseKit
//
//  Created by xiaheqi on 2021/4/21.
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

typedef NS_ENUM(NSInteger, BZResultType) {
    BZResultTypeFulfilled,
    BZResultTypeRejected
};
@interface BZResult : NSObject

@property (nonatomic, assign) BZResultType type;

@property (nonatomic, readonly, nullable) id value;

@property (nonatomic, readonly, nullable) NSError *error;

- (instancetype _Nonnull )initWithValue:(id _Nullable )value;
- (instancetype _Nonnull )initWithError:(NSError *_Nonnull)error;
@end
