//
//  BZResult.h
//  BZPromiseKit
//
//  Created by bzdqsmmz on 2021/4/22.
//

#import <Foundation/Foundation.h>

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
